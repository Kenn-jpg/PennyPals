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

    @State private var selectedCategory = "Eggs"
    let categories = ["Eggs", "Accessories", "Backgrounds", "Food"]
    let columns = [
        GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Shop").font(.largeTitle.bold()).foregroundColor(
                        .pennyText
                    )
                    Spacer()
                    Label(
                        "\(authVM.currentUser?.coins ?? 0)",
                        systemImage: "bitcoinsign.circle.fill"
                    ).font(.footnote.weight(.semibold)).padding(.horizontal, 10)
                        .padding(.vertical, 6).background(
                            .thinMaterial,
                            in: Capsule()
                        ).foregroundColor(.pennyText)
                }.padding(.horizontal).padding(.top, 20).padding(.bottom, 16)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                withAnimation(.spring()) {
                                    selectedCategory = category
                                }
                            }) {
                                Text(category).font(
                                    .subheadline.weight(.semibold)
                                ).padding(.horizontal, 16).padding(
                                    .vertical,
                                    10
                                )
                                .background(
                                    selectedCategory == category
                                        ? Color.pennyPurple
                                        : Color(hex: "#F3F0FF")
                                ).foregroundColor(
                                    selectedCategory == category
                                        ? .white : .pennySecondaryText
                                ).clipShape(Capsule())
                            }
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 20)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(
                            shopVM.shopItems.filter {
                                $0.category == selectedCategory
                            }
                        ) { item in
                            VStack(spacing: 12) {
                                EggView(
                                    color: item.colorHex ?? "#FFF",
                                    spots: item.spotsHex ?? "#CCC",
                                    size: 70
                                ).padding(.vertical, 10)
                                VStack(spacing: 4) {
                                    Text(item.name).font(.headline)
                                        .foregroundColor(.pennyText)
                                    HStack(spacing: 4) {
                                        Image(
                                            systemName:
                                                "bitcoinsign.circle.fill"
                                        ).foregroundColor(Color(hex: "#F2885F"))
                                        Text("\(item.price)").font(
                                            .subheadline.weight(.bold)
                                        ).foregroundColor(.pennyText)
                                    }
                                }
                                Button(action: {
                                    shopVM.purchaseItem(
                                        item: item,
                                        currentUserCoins: authVM.currentUser?
                                            .coins ?? 0
                                    )
                                }) {
                                    Text(
                                        shopVM.unlockedItemIds.contains(
                                            item.id ?? ""
                                        ) ? "Owned" : "Buy"
                                    ).font(.footnote.weight(.bold)).frame(
                                        maxWidth: .infinity
                                    ).padding(.vertical, 10)
                                        .background(Color(hex: "#F3F0FF"))
                                        .foregroundColor(
                                            shopVM.unlockedItemIds.contains(
                                                item.id ?? ""
                                            ) ? .gray : .pennyPurple
                                        ).clipShape(
                                            RoundedRectangle(cornerRadius: 12)
                                        )
                                }.disabled(
                                    shopVM.unlockedItemIds.contains(
                                        item.id ?? ""
                                    )
                                ).padding(.top, 4)
                            }.padding(16).background(
                                Color(UIColor.systemBackground)
                            ).clipShape(RoundedRectangle(cornerRadius: 24))
                                .shadow(
                                    color: .black.opacity(0.04),
                                    radius: 8,
                                    y: 4
                                )
                        }
                    }.padding(.horizontal).padding(.bottom, 24)
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
