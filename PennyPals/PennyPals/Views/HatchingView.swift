//
//  HatchingView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

internal import Combine
import SwiftUI

/// Antarmuka animasi penetasan telur yang muncul saat pengguna pertama kali menyelesaikan Onboarding atau ketika telur siap berevolusi.
struct HatchingView: View {

    /// ID yang mempresentasikan jenis warna/desain dari telur (misal: "rose", "mint", "sky").
    var eggId: String

    /// Closure yang dieksekusi tepat setelah animasi progress penetasan mencapai 100% (1.0).
    var onComplete: () -> Void

    @State private var progress: Double = 0.0
    @State private var isBouncing = false

    /// *Timer* terpusat pada *main thread* untuk merender perubahan progress bar animasi penetasan.
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    /// Properti terhitung (*Computed property*) untuk menentukan index frame sprite animasi berdasarkan persentase progress.
    private var currentFrameIndex: Int {
        let maxFrames = 7
        var index = Int(progress * Double(maxFrames)) + 1

        if index > maxFrames {
            index = maxFrames
        }
        return index
    }

    /// Memetakan `eggId` yang dipilih pengguna pada Onboarding ke prefix aset Xcode untuk menampilkan urutan gambar (*sprite sequence*).
    private var currentImageName: String {
        let baseName: String

        switch eggId {
        case "rose": baseName = "PinkEgg"
        case "mint": baseName = "GreenEgg"
        case "sky": baseName = "BlueEgg"
        case "sun": baseName = "YellowEgg"
        case "lilac": baseName = "PurpleEgg"
        case "peach": baseName = "PeachEgg"
        default: baseName = "BlueEgg"
        }

        let frameString = String(format: "%02d", currentFrameIndex)
        return "\(baseName)\(frameString)"
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Animasi visual telur
            ZStack {
                Image(currentImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .offset(y: isBouncing ? -10 : 10)
            }
            .frame(height: 150)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.0).repeatForever(autoreverses: true)
                ) {
                    isBouncing = true
                }
            }

            // Indikator Progress Bar
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
