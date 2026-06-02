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
    
    // FIX: default jangan "Eggs" lagi
    @State private var selectedCategory = "Accessories"
    
    // FIX: hanya 2 kategori yang tampil di UI
    let categories = ["Accessories", "Backgrounds"]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
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
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(shopVM.shopItems.filter { $0.category == selectedCategory }) { item in
                            VStack(spacing: 12) {
                                
                                // FIX: hilangkan EggView supaya tidak ada tampilan "egg" sama sekali di Shop UI
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(hex: "#F3F0FF"))
                                        .frame(height: 90)
                                    
                                    Image(systemName: selectedCategory == "Backgrounds" ? "photo.fill" : "tshirt.fill")
                                        .font(.system(size: 30, weight: .semibold))
                                        .foregroundColor(.pennyPurple)
                                }
                                .padding(.vertical, 10)
                                
                                VStack(spacing: 4) {
                                    Text(item.name)
                                        .font(.headline)
                                        .foregroundColor(.pennyText)
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "bitcoinsign.circle.fill")
                                            .foregroundColor(Color(hex: "#F2885F"))
                                        Text("\(item.price)")
                                            .font(.subheadline.weight(.bold))
                                            .foregroundColor(.pennyText)
                                    }
                                }
                                
                                let isOwned = shopVM.unlockedItemIds.contains(item.id ?? "")
                                let isBackground = item.category == "Backgrounds"
                                let isUsing = isBackground && (shopVM.selectedBackgroundId == item.id)
                                
                                // LALU Button ini menggantikan button lama
                                Button {
                                    if isBackground {
                                        if isOwned {
                                            shopVM.useBackground(item: item)
                                        } else {
                                            shopVM.purchaseItem(
                                                item: item,
                                                currentUserCoins: authVM.currentUser?.coins ?? 0
                                            )
                                        }
                                    } else {
                                        shopVM.purchaseItem(
                                            item: item,
                                            currentUserCoins: authVM.currentUser?.coins ?? 0
                                        )
                                    }
                                } label: {
                                    Text(
                                        isBackground
                                        ? (isUsing ? "Using" : (isOwned ? "Use" : "Buy"))
                                        : (isOwned ? "Owned" : "Buy")
                                    )
                                    .font(.footnote.weight(.bold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color(hex: "#F3F0FF"))
                                    .foregroundColor(
                                        isUsing ? .gray : (isOwned && !isBackground ? .gray : .pennyPurple)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .disabled(isUsing || (!isBackground && isOwned))
                                .padding(.top, 4)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
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
}
