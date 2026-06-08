//
//  InventoryView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseAuth
import SwiftUI

struct InventoryView: View {
    @Environment(\.dismiss) private var dismiss

    let category: String
    
    // Inject ShopViewModel to handle inventory logic
    @EnvironmentObject var shopVM: ShopViewModel

    private var ownedItems: [ShopItemModel] {
        shopVM.shopItems.filter {
            $0.category == self.category
                && shopVM.unlockedItemIds.contains($0.id ?? "")
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
                if let errorMessage = shopVM.errorMessage {
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
                // shopVM already listens to inventory and items from its init
            }
        }
    }

    // MARK: - Komponen Kartu Minimalis
    @ViewBuilder
    private func inventoryCard(for item: ShopItemModel) -> some View {
        let isEquipped = (category == "Backgrounds" ? shopVM.selectedBackgroundId == item.id : shopVM.selectedAccessoryId == item.id)

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
                    shopVM.toggleEquipItem(item: item)
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

}
