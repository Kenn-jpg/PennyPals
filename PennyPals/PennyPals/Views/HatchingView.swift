//
//  HatchingView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

internal import Combine
import SwiftUI

/// Tampilan transisi interaktif yang menyajikan animasi menetasnya telur menjadi hewan peliharaan sesaat setelah onboarding selesai disubmit.
struct HatchingView: View {
    /// ID tipe telur pilihan pengguna yang dioperasikan dari layar OnboardingView.
    var eggId: String
    /// Callback closure untuk mengeksekusi perpindahan halaman akhir menuju dashboard utama (HomeView).
    var onComplete: () -> Void

    /// Nilai pelacak tingkat kemajuan progres bar pemecahan telur (0.0 sampai 1.0).
    @State private var progress: Double = 0.0
    /// Pemicu visual efek animasi meloncat naik-turun pada gambar telur.
    @State private var isBouncing = false
    /// Timer Combine otomatis yang memicu interupsi berkala setiap 0.1 detik pada thread utama.
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    /// Properti komputasi matematis untuk merubah skala linear progress (0.0-1.0) menjadi urutan bingkai indeks gambar (1-7).
    private var currentFrameIndex: Int {
        let maxFrames = 7
        var index = Int(progress * Double(maxFrames)) + 1

        // Menjaga agar batas indeks terlindungi dan tidak melebihi total frame aset ke-7
        if index > maxFrames {
            index = maxFrames
        }
        return index
    }

    /// Properti komputasi perangkai nama file gambar secara dinamis dengan menggabungkan ID telur dan indeks bingkai.
    private var currentImageName: String {
        let baseName: String

        // Memetakan eggId ke struktur nama prefix Xcode Asset Catalog
        switch eggId {
        case "rose": baseName = "PinkEgg"
        case "mint": baseName = "GreenEgg"
        case "sky": baseName = "BlueEgg"
        case "sun": baseName = "YellowEgg"
        case "lilac": baseName = "PurpleEgg"
        default: baseName = "PinkEgg"
        }

        // Membentuk string urutan berkas dua digit (contoh: "BlueEgg01", "BlueEgg02", dst.)
        let frameString = String(format: "%02d", currentFrameIndex)
        return "\(baseName)\(frameString)"
    }

    var body: some View {
        VStack {
            Spacer()

            // Render Visual Gambar Animasi Melompat Karakter Telur
            ZStack {
                Image(currentImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 150)
                    .offset(y: isBouncing ? -10 : 10)
            }
            .frame(height: 150)
            .onAppear {
                // Memulai siklus animasi melompat konstan tak berujung secara otomatis
                withAnimation(
                    .easeInOut(duration: 1.0).repeatForever(autoreverses: true)
                ) {
                    isBouncing = true
                }
            }

            // Indikator Progres Bar Pemecahan Batang Cangkang Telur
            VStack(spacing: 16) {
                Text("Hatching...")
                    .font(.headline)
                    .foregroundColor(.pennyText)

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(UIColor.secondarySystemBackground))
                        .frame(height: 12)

                    Capsule()
                        .fill(Color.hatchingBarGradient)
                        .frame(width: progress * 300, height: 12)
                        .animation(.linear(duration: 0.1), value: progress)
                }
                .frame(width: 300)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pennyBackground.ignoresSafeArea())
        // Mengobservasi setiap pulsa emisi waktu yang dipancarkan oleh timer Combine
        .onReceive(timer) { _ in
            if progress < 1.0 {
                progress += 0.02  // Menaikkan isi progres bar secara berkala sebesar 2%
            } else {
                // Menghentikan koneksi langganan upstream timer secara bersih (Mencegah Memory Leak)
                timer.upstream.connect().cancel()

                // Memberikan delay jeda visual sepersekian detik sebelum melepas user ke HomeView
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onComplete()
                }
            }
        }
    }
}
