//
//  ShopScreen.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

struct ShopView: View {
    @StateObject private var shopVM = ShopViewModel()
    @EnvironmentObject var authVM: AuthViewModel

    @State private var selectedCategory = "Accessories"

    let categories = ["Accessories", "Backgrounds"]

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - HEADER
                HStack {
                    Text("Shop")
                        .font(.largeTitle.bold())
                        .foregroundColor(.pennyText)

                    Spacer()

                    Label(
                        "\(authVM.currentUser?.coins ?? 0)",
                        systemImage: "bitcoinsign.circle.fill"
                    )
                    .font(.footnote.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.thinMaterial, in: Capsule())
                    .foregroundColor(.pennyText)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 16)

                // MARK: - CATEGORY PICKER
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button {
                                withAnimation(.spring()) {
                                    selectedCategory = category
                                }
                            } label: {
                                Text(category)
                                    .font(.subheadline.weight(.semibold))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(
                                        selectedCategory == category
                                            ? Color.pennyPurple
                                            : Color(hex: "#F3F0FF")
                                    )
                                    .foregroundColor(
                                        selectedCategory == category
                                            ? .white
                                            : .pennySecondaryText
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)

                // MARK: - SHOP GRID ITEMS
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(
                            shopVM.shopItems.filter {
                                $0.category == selectedCategory
                            }
                        ) { item in

                            let isOwned = shopVM.unlockedItemIds.contains(
                                item.id ?? ""
                            )
                            let isBackground = item.category == "Backgrounds"
                            let isUsing =
                                isBackground
                                && (shopVM.selectedBackgroundId == item.id)

                            VStack(spacing: 0) {
                                // 1. Bagian Atas (Icon / Preview Warna)
                                ZStack {
                                    if isBackground {
                                        // 🔥 FIX GRADIENT: Cek apakah item berbentuk gradient
                                        if item.isGradient == true,
                                            let endColor = item.endColorHex
                                        {
                                            LinearGradient(
                                                colors: [
                                                    Color(
                                                        hex: item.colorHex
                                                            ?? "#E8E8E8"
                                                    ),
                                                    Color(hex: endColor),
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        } else {
                                            // Fallback ke warna solid jika bukan gradient
                                            Color(
                                                hex: item.colorHex ?? "#E8E8E8"
                                            )
                                        }

                                        // Tambahkan sedikit aksen 'spots' agar mirip dengan aslinya
                                        if let spotsHex = item.spotsHex {
                                            VStack {
                                                HStack {
                                                    Circle().fill(
                                                        Color(hex: spotsHex)
                                                    ).frame(width: 40).offset(
                                                        x: -10,
                                                        y: -10
                                                    )
                                                    Spacer()
                                                }
                                                Spacer()
                                                HStack {
                                                    Spacer()
                                                    Circle().fill(
                                                        Color(hex: spotsHex)
                                                    ).frame(width: 50).offset(
                                                        x: 10,
                                                        y: 15
                                                    )
                                                }
                                            }
                                        }
                                    } else {
                                        // Tampilkan Icon jika Accessories
                                        Color(hex: "#F3F0FF")

                                        Image(
                                            systemName: item.imageName
                                                ?? "tshirt.fill"
                                        )
                                        .font(
                                            .system(size: 32, weight: .semibold)
                                        )
                                        .foregroundColor(.pennyPurple)
                                    }
                                }
                                .frame(height: 100)
                                .clipped()  // Pastikan spots/circle tidak keluar dari batas

                                // 2. Bagian Bawah (Detail & Tombol)
                                VStack(spacing: 8) {
                                    Text(item.name)
                                        .font(.subheadline.weight(.bold))
                                        .foregroundColor(.pennyText)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)

                                    HStack(spacing: 4) {
                                        Image(
                                            systemName:
                                                "bitcoinsign.circle.fill"
                                        )
                                        .foregroundColor(Color(hex: "#F2885F"))
                                        Text("\(item.price)")
                                            .font(.footnote.weight(.bold))
                                            .foregroundColor(.pennyText)
                                    }

                                    // 3. Tombol Aksi
                                    Button {
                                        if isBackground {
                                            if isOwned {
                                                shopVM.useBackground(item: item)
                                            } else {
                                                shopVM.purchaseItem(
                                                    item: item,
                                                    currentUserCoins: authVM
                                                        .currentUser?.coins ?? 0
                                                )
                                            }
                                        } else {
                                            shopVM.purchaseItem(
                                                item: item,
                                                currentUserCoins: authVM
                                                    .currentUser?.coins ?? 0
                                            )
                                        }
                                    } label: {
                                        Text(
                                            isBackground
                                                ? (isUsing
                                                    ? "Using"
                                                    : (isOwned ? "Use" : "Buy"))
                                                : (isOwned ? "Owned" : "Buy")
                                        )
                                        .font(.footnote.weight(.bold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(Color(hex: "#F3F0FF"))
                                        .foregroundColor(
                                            isUsing
                                                ? .gray
                                                : (isOwned && !isBackground
                                                    ? .gray : .pennyPurple)
                                        )
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 12)
                                        )
                                    }
                                    .disabled(
                                        isUsing || (!isBackground && isOwned)
                                    )
                                    .padding(.top, 4)
                                }
                                .padding(12)
                            }
                            // Styling Container
                            .background(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(
                                color: Color.black.opacity(0.04),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
            .background(Color.pennyBackground.ignoresSafeArea())
            .alert(
                isPresented: Binding<Bool>(
                    get: { shopVM.errorMessage != nil },
                    set: { _ in shopVM.errorMessage = nil }
                )
            ) {
                Alert(
                    title: Text("Shop"),
                    message: Text(shopVM.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
