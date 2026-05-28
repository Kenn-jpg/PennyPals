//
//  ShopScreen.swift
//  PennyPals
//
//  Created by student on 28/05/26.
//


import SwiftUI

struct ShopView: View {
    @State private var selectedCategory = "Eggs"
    let categories = ["Eggs", "Accessories", "Backgrounds", "Food"]
    
    // Data dummy telur untuk Shop
    let shopItems = [
        ("Rosie", "#FFC9DE", "#FF94B8", 500),
        ("Sprout", "#B8EBD0", "#5FCB97", 500),
        ("Bloo", "#BFE0FF", "#5FA8E8", 500),
        ("Sunny", "#FFE3A8", "#F2B441", 500),
        ("Vio", "#D9C8FF", "#9B7CFF", 500),
        ("Pip", "#FFD0B8", "#F2885F", 500)
    ]
    
    // Konfigurasi 2 kolom mengikuti Apple HIG
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Header
                HStack {
                    Text("Shop")
                        .font(.largeTitle.bold())
                        .foregroundColor(.pennyText)
                    
                    Spacer()
                    
                    // Badge Koin di Kanan Atas
                    Label("1,240", systemImage: "bitcoinsign.circle.fill")
                        .font(.footnote.weight(.semibold))
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(.thinMaterial, in: Capsule())
                        .foregroundColor(.pennyText)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                // MARK: - Kategori (Bisa di-scroll)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedCategory = category
                                }
                            }) {
                                Text(category)
                                    .font(.subheadline.weight(.semibold))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(selectedCategory == category ? Color.pennyPurple : Color(hex: "#F3F0FF"))
                                    .foregroundColor(selectedCategory == category ? .white : .pennySecondaryText)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal)
                
                // MARK: - Grid Daftar Item
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(shopItems, id: \.0) { item in
                            VStack(spacing: 12) {
                                // Komponen Telur
                                EggView(color: item.1, spots: item.2, size: 70)
                                    .padding(.vertical, 10)
                                
                                VStack(spacing: 4) {
                                    Text(item.0)
                                        .font(.headline)
                                        .foregroundColor(.pennyText)
                                    
                                    // Harga dengan Ikon Koin
                                    HStack(spacing: 4) {
                                        Image(systemName: "bitcoinsign.circle.fill")
                                            .foregroundColor(Color(hex: "#F2885F"))
                                        Text("\(item.3)")
                                            .font(.subheadline.weight(.bold))
                                            .foregroundColor(.pennyText)
                                    }
                                }
                                
                                // Tombol Beli
                                Button(action: {}) {
                                    Text("Buy")
                                        .font(.footnote.weight(.bold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(Color(hex: "#F3F0FF"))
                                        .foregroundColor(.pennyPurple)
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                }
                                .padding(.top, 4)
                            }
                            .padding(16)
                            .background(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .background(Color.pennyBackground.ignoresSafeArea())
        }
    }
}
