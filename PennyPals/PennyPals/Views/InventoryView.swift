//
//  InventoryView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseAuth
import SwiftUI

/// Antarmuka yang menampilkan daftar aset kosmetik (Inventori) milik pengguna berdasarkan kategori tertentu.
struct InventoryView: View {
    @Environment(\.dismiss) private var dismiss

    /// Kategori barang yang sedang diakses (Contoh: "Accessories" atau "Backgrounds").
    let category: String

    @EnvironmentObject var shopVM: ShopViewModel

    /// Kumpulan barang dari toko yang sudah berhasil dibeli dan dimiliki oleh pengguna saat ini.
    private var ownedItems: [ShopItemModel] {
        shopVM.shopItems.filter {
            $0.category == self.category
                && shopVM.unlockedItemIds.contains($0.id ?? "")
        }
    }

    /// Konfigurasi tata letak dinamis berupa *Grid* dengan 2 kolom.
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
        }
    }

    /// Komponen visual (Card) untuk menampilkan detail pratinjau barang inventori beserta tombol pakainya.
    /// - Parameter item: Model barang toko (ShopItemModel) yang akan di-render.
    @ViewBuilder
    private func inventoryCard(for item: ShopItemModel) -> some View {
        let isEquipped =
            (category == "Backgrounds"
                ? shopVM.selectedBackgroundId == item.id
                : shopVM.selectedAccessoryId == item.id)

        VStack(spacing: 12) {
            ZStack {
                if category == "Backgrounds" {
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
                        Color(hex: item.colorHex ?? "#E8E8E8")
                    }

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
                    Color.white
                    Image(systemName: item.imageName ?? "tshirt.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.pennyPurple)
                }
            }
            .frame(height: 120)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)

            VStack(spacing: 4) {
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)

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
