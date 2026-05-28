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

    private var db = Firestore.firestore()
    private var userId: String? { Auth.auth().currentUser?.uid }

    init() {
        fetchShopItems()
        fetchUserInventory()
    }

    func fetchShopItems() {
        // Fallback dummy data jika firestore kosong
        self.shopItems = [
            ShopItemModel(
                id: "egg1",
                name: "Rosie",
                category: "Eggs",
                price: 500,
                colorHex: "#FFC9DE",
                spotsHex: "#FF94B8"
            ),
            ShopItemModel(
                id: "egg2",
                name: "Sprout",
                category: "Eggs",
                price: 500,
                colorHex: "#B8EBD0",
                spotsHex: "#5FCB97"
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
            self.unlockedItemIds =
                (try? snapshot?.data(as: UserInventoryModel.self))?
                .unlockedItemIds ?? []
        }
    }

    func purchaseItem(item: ShopItemModel, currentUserCoins: Int) {
        guard let uid = userId, let itemId = item.id else { return }

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
        batch.setData(
            [
                "userId": uid,
                "unlockedItemIds": FieldValue.arrayUnion([itemId]),
            ],
            forDocument: inventoryRef,
            merge: true
        )

        batch.commit { error in
            if let err = error { self.errorMessage = err.localizedDescription }
        }
    }
}
