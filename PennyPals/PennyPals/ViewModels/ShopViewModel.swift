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
    @Published var selectedBackgroundId: String?

    private var db = Firestore.firestore()
    private var userId: String? { Auth.auth().currentUser?.uid }

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

    func fetchShopItems() {
        self.shopItems = [
            ShopItemModel(
                id: "acc_hat",
                name: "Cute Hat",
                category: "Accessories",
                price: 150,
                colorHex: nil,
                spotsHex: nil,
                imageName: "tshirt.fill"
            ),
            ShopItemModel(
                id: "bg_softpink",
                name: "Soft Pink",
                category: "Backgrounds",
                price: 200,
                colorHex: "#FFF1F6",
                spotsHex: "#E8F4FF",
                imageName: nil
            ),
        ]

        db.collection("shopItems").getDocuments { snapshot, _ in
            if let docs = snapshot?.documents, !docs.isEmpty {
                self.shopItems = docs.compactMap {
                    try? $0.data(as: ShopItemModel.self)
                }
            }
        }
    }

    func fetchUserInventory() {
        guard let uid = userId else { return }
        db.collection("inventories").document(uid).addSnapshotListener {
            snapshot,
            _ in
            let inv = try? snapshot?.data(as: UserInventoryModel.self)
            self.unlockedItemIds = inv?.unlockedItemIds ?? []
            self.selectedBackgroundId = inv?.selectedBackgroundId

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
                    ]
                }
            PhoneConnectivity.shared.sendInventoryToWatch(
                ownedBackgrounds: ownedBgs,
                selectedBackgroundId: self.selectedBackgroundId
            )
        }
    }

    func purchaseItem(item: ShopItemModel, currentUserCoins: Int) {
        guard let uid = userId, let itemId = item.id else { return }

        // FIX: kalau sudah punya, jangan bisa beli lagi
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

        // Auto-equip kalau beli background
        if item.category == "Backgrounds" {
            data["selectedBackgroundId"] = itemId
        }

        batch.setData(data, forDocument: inventoryRef, merge: true)

        batch.commit { error in
            if let err = error {
                self.errorMessage = err.localizedDescription
            } else {
                // 🌟 TRIGGER WINK: Setelah pembelian berhasil, ubah mood pet menjadi wink!
                self.db.collection("pets").whereField("userId", isEqualTo: uid)
                    .getDocuments { snap, _ in
                        if let petDoc = snap?.documents.first {
                            petDoc.reference.updateData(["mood": "wink"])
                        }
                    }
            }
        }
    }

    func useBackground(item: ShopItemModel) {
        guard let uid = userId, let itemId = item.id else { return }

        // hanya boleh equip kalau sudah dimiliki
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

        // hanya boleh equip kalau sudah dimiliki
        guard unlockedItemIds.contains(id) else {
            self.errorMessage = "Beli dulu background-nya!"
            return
        }

        db.collection("inventories").document(uid).setData(
            ["selectedBackgroundId": id],
            merge: true
        )
    }
}
