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

    let category: String

    @State private var unlockedItemIds: [String] = []
    @State private var shopItems: [ShopItemModel] = []
    @State private var errorMessage: String?

    // State untuk item yang sedang dipakai (Equipped)
    @State private var equippedItemId: String? = nil

    private let db = Firestore.firestore()

    private var ownedItems: [ShopItemModel] {
        shopItems.filter {
            $0.category == self.category
                && unlockedItemIds.contains($0.id ?? "")
        }
    }

    // Konfigurasi Grid 2 Kolom
    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        NavigationStack {
            Group {
                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding()
                }

                if ownedItems.isEmpty {
                    ContentUnavailableView(
                        "No \(category) Yet",
                        systemImage: category == "Accessories"
                            ? "bag" : "photo",
                        description: Text(
                            "Beli \(category.lowercased()) di Shop, nanti muncul di sini."
                        )
                    )
                    .padding()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: gridColumns, spacing: 20) {
                            ForEach(ownedItems) { item in
                                inventoryCard(for: item)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(category)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .background(
                Color(UIColor.secondarySystemBackground).ignoresSafeArea()
            )
            .onAppear {
                startInventoryListener()
                fetchShopItems()
            }
        }
    }

    // MARK: - Komponen Kartu Minimalis
    @ViewBuilder
    private func inventoryCard(for item: ShopItemModel) -> some View {
        let isEquipped = equippedItemId == item.id

        VStack(spacing: 12) {
            // Preview Item (Kotak Visual)
            ZStack {
                if category == "Backgrounds" {
                    // Cek Gradient
                    if item.isGradient == true, let endColor = item.endColorHex
                    {
                        LinearGradient(
                            colors: [
                                Color(hex: item.colorHex ?? "#E8E8E8"),
                                Color(hex: endColor),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    } else {
                        // Fallback warna solid
                        Color(hex: item.colorHex ?? "#E8E8E8")
                    }

                    // Cek Spots (Bulatan)
                    if let spotsHex = item.spotsHex {
                        VStack {
                            HStack {
                                Circle()
                                    .fill(Color(hex: spotsHex))
                                    .frame(width: 40)
                                    .offset(x: -10, y: -10)
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(Color(hex: spotsHex))
                                    .frame(width: 50)
                                    .offset(x: 10, y: 15)
                            }
                        }
                    }
                } else {
                    // Tampilan default untuk aksesoris
                    Color.white
                    Image(systemName: item.imageName ?? "tshirt.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.pennyPurple)
                }
            }
            .frame(height: 120)
            .clipped()  // Pastikan spot tidak keluar batas
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)

            // Info Text
            VStack(spacing: 4) {
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                // Tombol Use / Equipped
                Button(action: {
                    equipItem(item)
                }) {
                    Text(isEquipped ? "Equipped" : "Use")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(isEquipped ? .white : .pennyPurple)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            isEquipped
                                ? Color.pennyPurple
                                : Color.pennyPurple.opacity(0.1)
                        )
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.03), radius: 8, y: 4)
    }

    // MARK: - Functions
    private func equipItem(_ item: ShopItemModel) {
        guard let uid = Auth.auth().currentUser?.uid, let itemId = item.id
        else { return }

        // 🌟 PERBAIKAN: Cek apakah item ini yang sedang dipakai. Jika iya, unequip (lepas).
        let isCurrentlyEquipped = (equippedItemId == itemId)

        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            equippedItemId = isCurrentlyEquipped ? nil : itemId
        }

        var updateData: [String: Any] = [:]
        if category == "Backgrounds" {
            // Jika dilepas hapus field, jika tidak set fieldnya
            updateData["selectedBackgroundId"] =
                isCurrentlyEquipped ? FieldValue.delete() : itemId
        } else if category == "Accessories" {
            updateData["selectedAccessoryId"] =
                isCurrentlyEquipped ? FieldValue.delete() : itemId
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

    private func startInventoryListener() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("inventories").document(uid).addSnapshotListener {
            snapshot,
            error in
            if let error {
                self.errorMessage = error.localizedDescription
                return
            }

            if let data = snapshot?.data() {
                self.unlockedItemIds =
                    data["unlockedItemIds"] as? [String] ?? []

                if self.category == "Backgrounds" {
                    self.equippedItemId =
                        data["selectedBackgroundId"] as? String
                } else if self.category == "Accessories" {
                    self.equippedItemId = data["selectedAccessoryId"] as? String
                }
            }
        }
    }

    private func fetchShopItems() {
        db.collection("shopItems").getDocuments { snapshot, error in
            if let error {
                self.errorMessage = error.localizedDescription
                return
            }

            self.shopItems =
                snapshot?.documents.compactMap { doc in
                    try? doc.data(as: ShopItemModel.self)
                } ?? []
        }
    }
}
