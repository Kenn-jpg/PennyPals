//
//  HatchingView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

internal import Combine
import SwiftUI

struct HatchingView: View {
    var eggId: String
    var onComplete: () -> Void

    @State private var progress: Double = 0.0
    @State private var isBouncing = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    // --- TAMBAHAN BARU: Menghitung frame gambar (1 sampai 7) berdasarkan progress ---
    private var currentFrameIndex: Int {
        let maxFrames = 7
        // Mengubah progress (0.0 - 1.0) menjadi index (1 - 7)
        var index = Int(progress * Double(maxFrames)) + 1

        // Memastikan index tidak melebihi 7 walaupun progress mencapai 1.0
        if index > maxFrames {
            index = maxFrames
        }
        return index
    }

    // --- TAMBAHAN BARU: Mendapatkan nama aset lengkap (contoh: BlueEgg01) ---
    private var currentImageName: String {
        let baseName: String

        // Mapping eggId dari OnboardingView ke nama folder/aset
        switch eggId {
        case "rose": baseName = "PinkEgg"
        case "mint": baseName = "GreenEgg"
        case "sky": baseName = "BlueEgg"
        case "sun": baseName = "YellowEgg"
        case "lilac": baseName = "PurpleEgg"
        case "peach": baseName = "PeachEgg"
        default: baseName = "BlueEgg"  // Fallback default
        }

        // Format angka menjadi 2 digit (1 -> "01", 7 -> "07")
        let frameString = String(format: "%02d", currentFrameIndex)
        return "\(baseName)\(frameString)"
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            ZStack {
                // --- DIUBAH: Menggunakan Image dari Assets berdasarkan frame ---
                Image(currentImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)  // Ukuran disesuaikan
                    .offset(y: isBouncing ? -10 : 10)  // Efek loncat tetap dipertahankan
            }
            .frame(height: 150)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.0).repeatForever(autoreverses: true)
                ) {
                    isBouncing = true
                }
            }

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
        .onReceive(timer) { _ in
            if progress < 1.0 {
                progress += 0.02
            } else {
                timer.upstream.connect().cancel()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onComplete()
                }
            }
        }
    }
}
