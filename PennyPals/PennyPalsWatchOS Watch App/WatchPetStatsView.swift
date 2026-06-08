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
            Spacer(minLength: 0)

            // MARK: - 1. Pet Character
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
                    .frame(width: 54, height: 54)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, y: 1)

                Image("\(connectivity.petType)\(moodSuffix)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
            }
            .offset(y: isBouncing ? -4 : 4)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true)
                ) {
                    isBouncing = true
                }
            }

            // MARK: - 2. Pet Name & Mood
            VStack(spacing: 0) {
                Text(connectivity.petName)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "#2A2440")) // Dark text
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                HStack(spacing: 4) {
                    Text(moodEmoji)
                        .font(.system(size: 10))
                    Text(connectivity.petMood.capitalized)
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "#6B6580")) // Darker secondary
                }
            }

            Spacer(minLength: 0)

            // MARK: - 3. Level Badge
            HStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "#9B7CFF"))

                Text("Level \(connectivity.petLevel)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#2A2440"))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Color.white.opacity(0.6),
                in: Capsule()
            )

            // MARK: - 4. XP Progress Bar
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

            // MARK: - 5. Connection Status
            if !connectivity.isConnected {
                HStack(spacing: 4) {
                    Image(systemName: "iphone.slash")
                        .font(.system(size: 9))
                    Text("Not synced")
                        .font(.system(size: 9))
                }
                .foregroundColor(.orange)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 4)
    }

    // MARK: - 6. Computed Properties

    private var xpProgress: CGFloat {
        guard connectivity.petMaxXP > 0 else { return 0 }
        return CGFloat(connectivity.petXP) / CGFloat(connectivity.petMaxXP)
    }

    private var moodEmoji: String {
        switch connectivity.petMood.lowercased() {
        case "happy": return "😊"
        case "sad": return "😢"
        case "hungry": return "🥺"
        case "angry": return "😡"
        case "cry": return "😭"
        case "dizzy": return "😵"
        case "sleepy": return "😴"
        case "surprised": return "😲"
        case "wink": return "😉"
        default: return "🐾"
        }
    }
    
    private var moodSuffix: String {
        switch connectivity.petMood.lowercased() {
        case "happy": return "Laugh"
        case "sad": return "Sad"
        case "hungry": return "TongueOut"
        case "angry": return "Angry"
        case "cry": return "Cry"
        case "dizzy": return "Dizzy"
        case "sleepy": return "Sleepy"
        case "surprised": return "Surprised"
        case "wink": return "WinkTongueOut"
        default: return "Laugh"
        }
    }
}



// MARK: - 7. Color Hex Extension

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
