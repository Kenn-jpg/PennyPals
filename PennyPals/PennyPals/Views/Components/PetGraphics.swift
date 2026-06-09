//
//  PetGraphics.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

/// Bentuk (Shape) kustom untuk menghasilkan siluet dasar yang menyerupai bentuk telur.
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

/// Komponen visual yang merender telur peliharaan sebelum menetas, lengkap dengan kustomisasi warna dasar dan warna corak.
struct EggView: View {
    /// Kode warna hex untuk warna dasar telur.
    var color: String

    /// Kode warna hex untuk motif/corak pada telur.
    var spots: String

    /// Ukuran dimensi dari telur.
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

/// Komponen visual yang bertugas memanggil dan menampilkan aset 2D hewan peliharaan berdasarkan jenis dan kondisinya.
struct PetView: View {
    /// Jenis spesies hewan peliharaan (contoh: "Cat", "Dog", "Owl", dsb).
    var petType: String

    /// Kondisi emosional hewan peliharaan (contoh: "happy", "sad", "hungry") yang didapat dari database.
    var mood: String

    /// Ukuran dimensi hewan peliharaan yang akan dirender di layar.
    var size: CGFloat

    /// Memetakan string mood dari database menjadi akhiran (suffix) penamaan aset gambar di Xcode.
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
        default: return "Laugh"
        }
    }

    /// Menggabungkan jenis peliharaan dan suffix mood untuk mendapatkan nama aset final (Contoh: "Cat" + "Laugh" = "CatLaugh").
    private var assetName: String {
        return "\(petType)\(moodSuffix)"
    }

    var body: some View {
        Image(assetName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
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
