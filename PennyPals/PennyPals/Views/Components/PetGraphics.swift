//
//  PetGraphics.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

// MARK: - Egg Graphics (Tetap menggunakan Shape karena sudah bagus)
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

// MARK: - Pet Graphics (DIUBAH MENGGUNAKAN ASSET)
struct PetView: View {
    var petType: String  // "Cat", "Dog", "Owl", "Pig", "Raccoon", "Seal"
    var mood: String  // "happy", "sad", "hungry", dll
    var size: CGFloat

    // Mapping mood dari HomeVM/Pet ke nama suffix Asset
    private var moodSuffix: String {
        switch mood.lowercased() {
        case "happy": return "Laugh"

        case "sad": return "Sad"
        case "hungry": return "TongueOut"
        case "angry": return "Angry"
        case "cry": return "Cry"
        case "dizzy": return "Dizzy"
        case "sleepy": return "Sleepy"
        case "surprised": return "Surprised"
        case "wink": return "WinkTongueOut"
        default: return "Laugh"  // Default fallback jika mood tidak dikenali
        }
    }

    // Gabungan jenis pet dan suffix (Contoh: "Cat" + "Laugh" = "CatLaugh")
    private var assetName: String {
        return "\(petType)\(moodSuffix)"
    }

    var body: some View {
        Image(assetName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            // Fallback image jika nama aset ternyata salah / belum masuk Xcode
            .overlay {
                if UIImage(named: assetName) == nil {
                    Text("Asset\nMissing")
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
    }
}
