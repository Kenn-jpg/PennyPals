//
//  ShopViewModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

internal import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation

// ViewModel yang mengelola seluruh data berkaitan dengan toko (Shop) dan inventori aset virtual pengguna.
// Bertanggung jawab untuk mengambil daftar item yang dijual, memproses transaksi pembelian,
// serta mengelola item yang digunakan (Equipped) seperti latar belakang dan aksesoris.
@MainActor
class ShopViewModel: ObservableObject {
    // MARK: - Properties

    // Daftar lengkap item yang tersedia di toko, baik aksesoris maupun background.
    @Published var shopItems: [ShopItemModel] = []
    
    // Kumpulan ID item yang telah berhasil dibeli oleh pengguna.
    @Published var unlockedItemIds: [String] = []
    
    // Pesan error yang muncul jika ada masalah saat pembelian atau pengambilan data.
    @Published var errorMessage: String?
    
    // ID dari item latar belakang (Background) yang saat ini sedang aktif digunakan.
    @Published var selectedBackgroundId: String?
    
    // ID dari item aksesoris (Accessory) yang saat ini sedang aktif digunakan.
    @Published var selectedAccessoryId: String?

    private var db = Firestore.firestore()
    private var userId: String? { Auth.auth().currentUser?.uid }

    // MARK: - Initialization

    init() {
        fetchShopItems()
        fetchUserInventory()

        NotificationCenter.default.addObserver(
            forName: .watchRequestedEquipBackground,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let id = notification.userInfo?["id"] as? String {
                self?.useBackground(id: id)
            }
        }
    }

    // MARK: - 1. Data Fetching

    // Mengambil seluruh data item toko dari database Firebase secara *real-time*.
    // Jika terjadi kesalahan atau data kosong, akan menggunakan daftar fallback bawaan.
    func fetchShopItems() {
        // Data default sebagai fallback jika Firebase kosong/gagal
        let defaultItems = [
            ShopItemModel(
                id: "acc_hat",
                name: "Cute Hat",
                category: "Accessories",
                price: 150,
                colorHex: nil,
                spotsHex: nil,
                imageName: "tshirt.fill",
                isGradient: false,
                endColorHex: nil
            )
        ]

        // Menggunakan SnapshotListener agar sinkronisasi dengan Firebase berjalan secara real-time
        db.collection("shopItems").addSnapshotListener {
            [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print(
                    "❌ Error fetching shop items: \(error.localizedDescription)"
                )
                self.shopItems = defaultItems
                return
            }

            guard let docs = snapshot?.documents, !docs.isEmpty else {
                print("⚠️ Collection shopItems kosong di Firebase!")
                self.shopItems = defaultItems
                return
            }

            var fetchedItems: [ShopItemModel] = []

            for doc in docs {
                do {
                    let item = try doc.data(as: ShopItemModel.self)
                    fetchedItems.append(item)
                } catch {
                    print(
                        "❌ Error Decoding Item di Firebase (ID: \(doc.documentID)): \(error)"
                    )
                }
            }

            // Gabungkan dengan defaultItems (Cute Hat) jika belum ada di Firebase
            var finalItems = fetchedItems
            for dItem in defaultItems {
                if !finalItems.contains(where: { $0.id == dItem.id }) {
                    finalItems.append(dItem)
                }
            }

            self.shopItems = finalItems
        }
    }

    // Memantau data inventori milik pengguna saat ini dan mengsinkronisasikannya dengan WatchOS.
    // Ini memastikan item yang sudah dibeli dan digunakan langsung ter-update di UI.
    func fetchUserInventory() {
        guard let uid = userId else { return }
        db.collection("inventories").document(uid).addSnapshotListener {
            snapshot,
            _ in
            let inv = try? snapshot?.data(as: UserInventoryModel.self)
            self.unlockedItemIds = inv?.unlockedItemIds ?? []
            self.selectedBackgroundId = inv?.selectedBackgroundId
            self.selectedAccessoryId = inv?.selectedAccessoryId

            // 📲 Forward owned backgrounds ke Watch
            let ownedBgs = self.shopItems
                .filter {
                    $0.category == "Backgrounds"
                        && self.unlockedItemIds.contains($0.id ?? "")
                }
                .map { item -> [String: String] in
                    [
                        "id": item.id ?? "",
                        "name": item.name,
                        "colorHex": item.colorHex ?? "#1A1A2E",
                        "spotsHex": item.spotsHex ?? "#16213E",
                        "isGradient": String(item.isGradient ?? false),
                        "endColorHex": item.endColorHex ?? item.colorHex ?? "",
                    ]
                }
            PhoneConnectivity.shared.sendInventoryToWatch(
                ownedBackgrounds: ownedBgs,
                selectedBackgroundId: self.selectedBackgroundId
            )
        }
    }

    // MARK: - 2. Purchase Operations

    // Memproses pembelian item baru menggunakan koin pengguna.
    func purchaseItem(item: ShopItemModel, currentUserCoins: Int) {
        guard let uid = userId, let itemId = item.id else { return }

        if unlockedItemIds.contains(itemId) {
            self.errorMessage = "Item sudah dimiliki!"
            return
        }

        if currentUserCoins < item.price {
            self.errorMessage = "Koin tidak cukup!"
            return
        }

        let batch = db.batch()

        let userRef = db.collection("users").document(uid)
        batch.updateData(
            ["coins": currentUserCoins - item.price],
            forDocument: userRef
        )

        let inventoryRef = db.collection("inventories").document(uid)

        var data: [String: Any] = [
            "userId": uid,
            "unlockedItemIds": FieldValue.arrayUnion([itemId]),
        ]

        if item.category == "Backgrounds" {
            data["selectedBackgroundId"] = itemId
        }

        batch.setData(data, forDocument: inventoryRef, merge: true)

        batch.commit { error in
            if let err = error {
                self.errorMessage = err.localizedDescription
            } else {
                self.db.collection("pets").whereField("userId", isEqualTo: uid)
                    .getDocuments { snap, _ in
                        if let petDoc = snap?.documents.first {
                            petDoc.reference.updateData(["mood": "wink"])
                        }
                    }
            }
        }
    }

    // MARK: - 3. Equip Items

    func useBackground(item: ShopItemModel) {
        guard let uid = userId, let itemId = item.id else { return }

        guard unlockedItemIds.contains(itemId) else {
            self.errorMessage = "Beli dulu background-nya!"
            return
        }

        db.collection("inventories").document(uid).setData(
            ["selectedBackgroundId": itemId],
            merge: true
        )
    }

    func useBackground(id: String) {
        guard let uid = userId else { return }

        guard unlockedItemIds.contains(id) else {
            self.errorMessage = "Beli dulu background-nya!"
            return
        }

        db.collection("inventories").document(uid).setData(
            ["selectedBackgroundId": id],
            merge: true
        )
    }

    // Mengganti status pakai (Equip / Unequip) dari sebuah item.
    func toggleEquipItem(item: ShopItemModel) {
        guard let uid = userId, let itemId = item.id else { return }

        guard unlockedItemIds.contains(itemId) else {
            self.errorMessage = "Beli dulu item-nya!"
            return
        }

        var updateData: [String: Any] = [:]
        
        if item.category == "Backgrounds" {
            let isCurrentlyEquipped = (self.selectedBackgroundId == itemId)
            updateData["selectedBackgroundId"] = isCurrentlyEquipped ? FieldValue.delete() : itemId
        } else if item.category == "Accessories" {
            let isCurrentlyEquipped = (self.selectedAccessoryId == itemId)
            updateData["selectedAccessoryId"] = isCurrentlyEquipped ? FieldValue.delete() : itemId
        }

        db.collection("inventories").document(uid).setData(
            updateData,
            merge: true
        ) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
