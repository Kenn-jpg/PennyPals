//
//  InventoryView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct InventoryView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var unlockedItemIds: [String] = []
    @State private var shopItems: [ShopItemModel] = []
    @State private var errorMessage: String?

    private let db = Firestore.firestore()

    private var ownedAccessories: [ShopItemModel] {
        shopItems.filter {
            $0.category == "Accessories"
                && unlockedItemIds.contains($0.id ?? "")
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding()
                }

                if ownedAccessories.isEmpty {
                    ContentUnavailableView(
                        "No Accessories Yet",
                        systemImage: "bag",
                        description: Text(
                            "Beli accessories di Shop, nanti muncul di sini."
                        )
                    )
                    .padding()
                } else {
                    List {
                        ForEach(ownedAccessories) { item in
                            HStack(spacing: 12) {
                                Image(
                                    systemName: item.imageName ?? "tshirt.fill"
                                )
                                .foregroundColor(.pennyPurple)
                                .frame(width: 28)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name).font(.headline)
                                    Text("Owned")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Inventory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .onAppear {
                startInventoryListener()
                fetchShopItems()
            }
        }
    }

    private func startInventoryListener() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("inventories").document(uid).addSnapshotListener {
            snapshot,
            error in
            if let error {
                self.errorMessage = error.localizedDescription
                return
            }
            let inv = try? snapshot?.data(as: UserInventoryModel.self)
            self.unlockedItemIds = inv?.unlockedItemIds ?? []

            // Debug (hapus kalau sudah oke)
            print("Inventory unlockedItemIds:", self.unlockedItemIds)
        }
    }

    private func fetchShopItems() {
        db.collection("shopItems").getDocuments { snapshot, error in
            if let error {
                self.errorMessage = error.localizedDescription
                return
            }

            let docs = snapshot?.documents ?? []
            print("Shop items docs count:", docs.count)

            self.shopItems = docs.compactMap { doc in
                do {
                    let item = try doc.data(as: ShopItemModel.self)
                    return item
                } catch {
                    print(
                        "❌ Decode shopItem failed for docID=\(doc.documentID):",
                        error
                    )
                    print("Raw data:", doc.data())
                    return nil
                }
            }

            print("Shop items ids:", self.shopItems.compactMap { $0.id })
        }
    }
}
