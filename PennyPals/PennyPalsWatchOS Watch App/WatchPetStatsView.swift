//
//  WatchPetStatsView.swift
//  PennyPalsWatchOS Watch App
//
//  Created by Kelompok 8 on 03/06/26.
//

import SwiftUI

struct WatchPetStatsView: View {
    @EnvironmentObject var connectivity: IOSConnectivity

    @State private var isBouncing = false

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {

                // --- Pet Character ---
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#FFE8F1"),
                                    Color(hex: "#E8DCFF"),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)

                    WatchPetView(
                        mood: connectivity.petMood,
                        size: 90
                    )
                    .offset(y: isBouncing ? -4 : 4)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                        ) {
                            isBouncing = true
                        }
                    }
                }

                // --- Pet Name & Mood ---
                VStack(spacing: 4) {
                    Text(connectivity.petName)
                        .font(.headline)
                        .foregroundColor(.white)

                    HStack(spacing: 4) {
                        Text(moodEmoji)
                            .font(.caption)
                        Text(connectivity.petMood.capitalized)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                // --- Level Badge ---
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "#9B7CFF"))

                    Text("Level \(connectivity.petLevel)")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Color(hex: "#9B7CFF").opacity(0.25),
                    in: Capsule()
                )

                // --- XP Progress Bar ---
                VStack(spacing: 6) {
                    HStack {
                        Text("XP")
                            .font(.caption2.weight(.medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(connectivity.petXP) / \(connectivity.petMaxXP)")
                            .font(.caption2.weight(.bold))
                            .foregroundColor(Color(hex: "#9B7CFF"))
                    }

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.15))
                                .frame(height: 8)

                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "#FF8FB5"),
                                            Color(hex: "#9B7CFF"),
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: xpProgress * geo.size.width,
                                    height: 8
                                )
                                .animation(.easeOut(duration: 0.5), value: connectivity.petXP)
                        }
                    }
                    .frame(height: 8)
                }
                .padding(.horizontal, 4)

                // --- Connection Status ---
                if !connectivity.isConnected {
                    HStack(spacing: 4) {
                        Image(systemName: "iphone.slash")
                            .font(.caption2)
                        Text("Not synced")
                            .font(.caption2)
                    }
                    .foregroundColor(.orange)
                    .padding(.top, 4)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
    }

    // MARK: - Computed Properties

    private var xpProgress: CGFloat {
        guard connectivity.petMaxXP > 0 else { return 0 }
        return CGFloat(connectivity.petXP) / CGFloat(connectivity.petMaxXP)
    }

    private var moodEmoji: String {
        switch connectivity.petMood {
        case "happy": return "😊"
        case "sad": return "😢"
        case "hungry": return "🥺"
        default: return "🐾"
        }
    }
}

// MARK: - Watch-compatible Pet View (simplified PetView without UIKit)

struct WatchPetView: View {
    var mood: String
    var size: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.4)
                .fill(Color(hex: "#FFC9DE"))
                .frame(width: size * 0.75, height: size * 0.7)

            HStack(spacing: size * 0.15) {
                if mood == "sad" {
                    Text("T_T")
                        .font(.system(size: size * 0.12, weight: .bold))
                        .foregroundColor(Color(hex: "#2A2440"))
                    Text("T_T")
                        .font(.system(size: size * 0.12, weight: .bold))
                        .foregroundColor(Color(hex: "#2A2440"))
                } else if mood == "hungry" {
                    Text("🥺").font(.system(size: size * 0.2))
                    Text("🥺").font(.system(size: size * 0.2))
                } else {
                    Text("^-^")
                        .font(.system(size: size * 0.12, weight: .bold))
                        .foregroundColor(Color(hex: "#2A2440"))
                    Text("^-^")
                        .font(.system(size: size * 0.12, weight: .bold))
                        .foregroundColor(Color(hex: "#2A2440"))
                }
            }
            .offset(y: -size * 0.04)

            Text("🔺")
                .font(.system(size: size * 0.07))
                .rotationEffect(.degrees(180))
                .offset(y: size * 0.08)
        }
    }
}

// MARK: - Color Hex Extension (Watch-compatible, no UIKit)

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
