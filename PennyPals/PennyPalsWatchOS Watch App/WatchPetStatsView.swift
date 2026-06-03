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
        VStack(spacing: 4) {

            // --- Header: Pet & Name ---
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.8),
                                    Color.white.opacity(0.4),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)

                    WatchPetView(
                        mood: connectivity.petMood,
                        size: 36
                    )
                    .offset(y: isBouncing ? -1 : 1)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                        ) {
                            isBouncing = true
                        }
                    }
                }
                .shadow(color: Color.black.opacity(0.1), radius: 2, y: 1)

                VStack(alignment: .leading, spacing: 0) {
                    Text(connectivity.petName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(hex: "#2A2440"))
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Text(moodEmoji)
                            .font(.system(size: 10))
                        Text(connectivity.petMood.capitalized)
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "#6B6580"))
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 4)
            .padding(.top, 2)

            // --- Level Badge ---
            HStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.system(size: 9))
                    .foregroundColor(Color(hex: "#9B7CFF"))

                Text("Level \(connectivity.petLevel)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#2A2440"))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Color.white.opacity(0.6),
                in: Capsule()
            )

            // --- XP Progress Bar ---
            VStack(spacing: 4) {
                HStack {
                    Text("XP")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(Color(hex: "#6B6580"))
                    Spacer()
                    Text("\(connectivity.petXP) / \(connectivity.petMaxXP)")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(Color(hex: "#9B7CFF"))
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(hex: "#2A2440").opacity(0.1))
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 3)
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
                                height: 6
                            )
                            .animation(.easeOut(duration: 0.5), value: connectivity.petXP)
                    }
                }
                .frame(height: 6)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Color.white.opacity(0.6),
                in: RoundedRectangle(cornerRadius: 8)
            )

            // --- Connection Status ---
            if !connectivity.isConnected {
                HStack(spacing: 4) {
                    Image(systemName: "iphone.slash")
                        .font(.system(size: 8))
                    Text("Not synced")
                        .font(.system(size: 8))
                }
                .foregroundColor(.orange)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 2)
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
