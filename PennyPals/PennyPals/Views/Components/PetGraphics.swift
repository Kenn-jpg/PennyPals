//
//  PetGraphics.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

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
            EggShape().fill(Color(hex: color)).frame(
                width: size,
                height: size * 1.2
            )
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

struct PetView: View {
    var mood: String
    var size: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.4).fill(
                Color(hex: "#FFC9DE")
            ).frame(width: size * 0.85, height: size * 0.8)

            HStack(spacing: size * 0.2) {
                if mood == "sad" {
                    Text("T_T").font(.system(size: size * 0.15, weight: .bold))
                        .foregroundColor(Color(hex: "#2A2440"))
                    Text("T_T").font(.system(size: size * 0.15, weight: .bold))
                        .foregroundColor(Color(hex: "#2A2440"))
                } else if mood == "hungry" {
                    Text("🥺").font(.system(size: size * 0.25))
                    Text("🥺").font(.system(size: size * 0.25))
                } else {
                    Text("^-^").font(.system(size: size * 0.15, weight: .bold))
                        .foregroundColor(Color(hex: "#2A2440"))
                    Text("^-^").font(.system(size: size * 0.15, weight: .bold))
                        .foregroundColor(Color(hex: "#2A2440"))
                }
            }
            .offset(y: -size * 0.05)

            Text("🔺").font(.system(size: size * 0.08)).foregroundColor(
                Color(hex: "#F2885F")
            ).rotationEffect(.degrees(180)).offset(y: size * 0.08)
        }
    }
}
