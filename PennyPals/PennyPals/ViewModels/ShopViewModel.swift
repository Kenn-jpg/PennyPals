//
//  ShopViewModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

internal import Combine
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
            Task { @MainActor in
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
    }

    // MARK: - Ambil Inventaris Pengguna
    func fetchUserInventory() {
        guard let uid = userId else { return }

        db.collection("inventories").whereField("userId", isEqualTo: uid)
            .addSnapshotListener { snapshot, error in
                Task { @MainActor in
                    guard let document = snapshot?.documents.first else {
                        return
                    }
                    let inventory = try? document.data(
                        as: UserInventoryModel.self
                    )
                    self.unlockedItemIds = inventory?.unlockedItemIds ?? []
                }
            }
    }

    // MARK: - Logika Pembelian
    func purchaseItem(item: ShopItemModel, currentUserCoins: Int) {
        guard let uid = userId, let itemId = item.id else { return }

        if currentUserCoins < item.price {
            self.errorMessage = "Koin tidak cukup untuk membeli \(item.name)!"
            return
        }

        if unlockedItemIds.contains(itemId) {
            self.errorMessage = "Kamu sudah memiliki \(item.name)!"
            return
        }

        let batch = db.batch()

        let userRef = db.collection("users").document(uid)
        batch.updateData(
            ["coins": currentUserCoins - item.price],
            forDocument: userRef
        )

        let inventoryRef = db.collection("inventories").document(uid)
        batch.setData(
            [
                "userId": uid,
                "unlockedItemIds": FieldValue.arrayUnion([itemId]),
            ],
            forDocument: inventoryRef,
            merge: true
        )

        batch.commit { error in
            Task { @MainActor in
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
}
