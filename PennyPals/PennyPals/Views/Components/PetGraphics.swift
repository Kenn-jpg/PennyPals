//
//  PetGraphics.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

// MARK: - Egg Graphic
struct EggShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(
            in: CGRect(
                x: rect.minX,
                y: rect.minY + rect.height * 0.1,
                width: rect.width,
                height: rect.height * 0.9
            )
        )
        return path
    }
}

struct EggView: View {
    var color: String
    var spots: String
    var size: CGFloat

    var body: some View {
        ZStack {
            EggShape()
                .fill(Color(hex: color))
                .frame(width: size, height: size * 1.2)
            Circle().fill(Color(hex: spots)).frame(width: size * 0.15).offset(
                x: -size * 0.15,
                y: -size * 0.1
            )
            Circle().fill(Color(hex: spots)).frame(width: size * 0.2).offset(
                x: size * 0.15,
                y: size * 0.15
            )
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Pet Graphic (Image 0 & 3 Visual)
struct PetView: View {
    var mood: String  // "hungry" atau "happy"
    var size: CGFloat

    var body: some View {
        ZStack {
            // Badan Pet: Memperbarui bentuk agar lebih mirip blob di Image 0/3 (bukan lingkaran sempurna)
            RoundedRectangle(cornerRadius: size * 0.4)
                .fill(Color(hex: "#FFC9DE"))
                .frame(width: size * 0.85, height: size * 0.8)

            // Ekspresi Wajah (Image 0 vs Image 3)
            HStack(spacing: size * 0.2) {
                if mood == "hungry" {
                    // Mata memelas (Image 0)
                    Text("🥺").font(.system(size: size * 0.25))
                    Text("🥺").font(.system(size: size * 0.25))
                } else {
                    // Mata senang (Image 3 - placeholder)
                    Text("^-^").font(.system(size: size * 0.15, weight: .bold))
                        .foregroundColor(Color(hex: "#2A2440"))
                    Text("^-^").font(.system(size: size * 0.15, weight: .bold))
                        .foregroundColor(Color(hex: "#2A2440"))
                }
            }
            .offset(y: -size * 0.05)

            // Mulut
            Text("🔺")
                .font(.system(size: size * 0.08))
                .foregroundColor(Color(hex: "#F2885F"))
                .rotationEffect(.degrees(180))
                .offset(y: size * 0.08)
        }
    }
}
