//
//  ShopViewModel.swift
//  PennyPals
//
//  Created by Keane Juan Suryanto on 28/05/26.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

@MainActor
class ShopViewModel: ObservableObject {
    @Published var shopItems: [ShopItemModel] = []
    @Published var unlockedItemIds: [String] = []
    @Published var errorMessage: String?
    @Published var purchaseSuccess: Bool = false

    private var db = Firestore.firestore()
    private var userId: String? { Auth.auth().currentUser?.uid }

    init() {
        fetchShopItems()
        fetchUserInventory()
    }

    // MARK: - Ambil Data Barang dari Firestore
    func fetchShopItems() {
        db.collection("shopItems").getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            self.shopItems =
                snapshot?.documents.compactMap { document in
                    try? document.data(as: ShopItemModel.self)
                } ?? []
        }
    }

    // MARK: - Ambil Inventaris Pengguna
    func fetchUserInventory() {
        guard let uid = userId else { return }

        db.collection("inventories").whereField("userId", isEqualTo: uid)
            .addSnapshotListener { snapshot, error in
                guard let document = snapshot?.documents.first else { return }
                let inventory = try? document.data(as: UserInventoryModel.self)
                self.unlockedItemIds = inventory?.unlockedItemIds ?? []
            }
    }

    // MARK: - Logika Pembelian
    func purchaseItem(item: ShopItemModel, currentUserCoins: Int) {
        guard let uid = userId, let itemId = item.id else { return }

        // 1. Cek apakah koin cukup
        if currentUserCoins < item.price {
            self.errorMessage = "Koin tidak cukup untuk membeli \(item.name)!"
            return
        }

        // 2. Cek apakah barang sudah dimiliki (opsional, jika barangnya permanen)
        if unlockedItemIds.contains(itemId) {
            self.errorMessage = "Kamu sudah memiliki \(item.name)!"
            return
        }

        let batch = db.batch()

        // 3. Kurangi koin pengguna di koleksi 'users'
        let userRef = db.collection("users").document(uid)
        batch.updateData(
            ["coins": currentUserCoins - item.price],
            forDocument: userRef
        )

        // 4. Tambahkan barang ke inventaris pengguna
        // (Asumsi dokumen inventaris menggunakan ID yang sama dengan userId untuk kemudahan)
        let inventoryRef = db.collection("inventories").document(uid)
        batch.setData(
            [
                "userId": uid,
                "unlockedItemIds": FieldValue.arrayUnion([itemId]),
            ],
            forDocument: inventoryRef,
            merge: true
        )

        // 5. Eksekusi Batch Firestore
        batch.commit { error in
            if let error = error {
                self.errorMessage =
                    "Gagal membeli barang: \(error.localizedDescription)"
            } else {
                self.purchaseSuccess = true
                self.errorMessage = "Berhasil membeli \(item.name)!"
            }
        }
    }
}
