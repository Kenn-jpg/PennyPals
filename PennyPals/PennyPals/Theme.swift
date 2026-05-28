//
//  Theme.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

// MARK: - Reusable Button Style
struct PennyPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#FF8FB5"), Color(hex: "#9B7CFF")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .shadow(
                color: Color(hex: "#9B7CFF").opacity(0.3),
                radius: 10,
                x: 0,
                y: 5
            )
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Ekstensi Warna Semantic & Gradasi
extension Color {
    // Gradasi Latar Belakang Utama (Pink ke Biru Muda)
    static let pennyBackground = LinearGradient(
        colors: [Color(hex: "#FFF1F6"), Color(hex: "#E8F4FF")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Gradasi Bar Menetas (Image 1: Hijau -> Biru -> Pink)
    static let hatchingBarGradient = LinearGradient(
        colors: [
            Color(hex: "#5FCB97"), Color(hex: "#5FA8E8"), Color(hex: "#FF8FB5"),
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let pennyText = Color(hex: "#2A2440")
    static let pennySecondaryText = Color(hex: "#7A7494")
    static let pennyPurple = Color(hex: "#9B7CFF")
}

// MARK: - Konverter Warna Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (
                255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17
            )
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (
                int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF
            )
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
