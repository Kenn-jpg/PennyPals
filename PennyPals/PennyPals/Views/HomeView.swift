//
//  HomeScreen.swift
//  PennyPals
//
//  Created by student on 28/05/26.
//

import SwiftUI

struct HomeView: View {
    var savingsAmount: String
    @State private var isBouncing = false
    @State private var showSavingsModal = false
    @State private var petMood: String = "hungry"
    @State private var bubbleText: String = "I'm hungry — let's save! 🍓"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Header Section
                HStack {
                    HStack {
                        Circle()
                            .fill(LinearGradient(colors: [Color(hex: "#FF8FB5"), .pennyPurple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 44, height: 44)
                            .overlay(Text("JM").font(.headline).foregroundColor(.white))
                        
                        VStack(alignment: .leading) {
                            Text("Welcome back").font(.caption).foregroundColor(.pennySecondaryText)
                            Text("Jamie").font(.headline).foregroundColor(.pennyText)
                        }
                    }
                    Spacer()
                    HStack {
                        Label("Lv 7", systemImage: "sparkles")
                            .font(.footnote.weight(.semibold))
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(.thinMaterial, in: Capsule())
                            .foregroundColor(.pennyText)
                        
                        Label("1,240", systemImage: "bitcoinsign.circle.fill")
                            .font(.footnote.weight(.semibold))
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(.thinMaterial, in: Capsule())
                            .foregroundColor(.pennyText)
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 0)
                
                // Centerpiece Pet
                VStack(spacing: 12) {
                    Text(bubbleText)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.pennyText)
                        .padding()
                        .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                    
                    ZStack(alignment: .topTrailing) {
                        Circle()
                            .fill(LinearGradient(colors: [Color(hex: "#FFE8F1"), Color(hex: "#E8DCFF")], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 200, height: 200)
                        
                        PetView(mood: petMood, size: 180)
                            .offset(y: isBouncing ? -5 : 5)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isBouncing)
                            .onAppear { isBouncing = true }
                        
                        Label("12d streak", systemImage: "flame.fill")
                            .font(.caption.weight(.bold))
                            .foregroundColor(Color(hex: "#7A4A2A"))
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(Color(hex: "#FFEDC4"), in: Capsule())
                            .offset(x: 20, y: 10)
                    }
                }
                
                Spacer(minLength: 0)
                
                // Modul Progress & Tombol
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Pet XP").font(.subheadline.weight(.medium)).foregroundColor(.pennySecondaryText)
                            Spacer()
                            Text("720 / 1000").font(.subheadline.bold()).foregroundColor(.pennyPurple)
                        }
                        ProgressView(value: 720, total: 1000)
                            .tint(.pennyPurple)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Penalty", systemImage: "exclamationmark.triangle.fill")
                                .font(.caption.weight(.medium))
                                .foregroundColor(.orange)
                            Text("Safe ✓").font(.headline)
                            Text("Next check 2d").font(.caption2).foregroundColor(.pennySecondaryText)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Wishlist", systemImage: "target")
                                .font(.caption.weight(.medium))
                                .foregroundColor(.pennyPurple)
                            Text("AirPods Pro").font(.subheadline.weight(.semibold)).lineLimit(1)
                            ProgressView(value: 1.8, total: 4.0)
                                .tint(.blue)
                            Text("Rp 1,8jt / Rp 4jt").font(.caption2).foregroundColor(.pennySecondaryText)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                    
                    Button(action: { showSavingsModal = true }) {
                        Label("Manual Input", systemImage: "plus")
                    }
                    .buttonStyle(PennyPrimaryButtonStyle())
                }
                .padding(.horizontal)
                
                Spacer(minLength: 0)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pennyBackground.ignoresSafeArea())
            .sheet(isPresented: $showSavingsModal) {
                AddSavingsModal(onSave: {
                    petMood = "happy"
                    bubbleText = "Yay! Thanks for saving! 🍓"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        petMood = "hungry"
                        bubbleText = "I'm hungry — let's save! 🍓"
                    }
                })
            }
        }
    }
}
