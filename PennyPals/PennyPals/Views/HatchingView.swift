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
    @State private var isAnimatingEgg = false

    // Ambil nama pet berdasarkan ID (untuk teks Image 1)
    var petName: String {
        switch eggId {
        case "rose": return "Rosie"
        case "mint": return "Sprout"
        case "sky": return "Bloo"
        default: return "Pal"
        }
    }

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Telur yang melayang (Image 1)
            ZStack {
                // Placeholder grafis telur
                EggView(color: "#FFC9DE", spots: "#FF94B8", size: 120)
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

            VStack(spacing: 16) {
                // Teks Proses (Image 1)
                Text("Hatching \(petName)...")
                    .font(.headline)
                    .foregroundColor(.pennyText)

                // Bar Proses Native dengan Gradasi Khusus (Image 1)
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(UIColor.secondarySystemBackground))
                        .frame(height: 12)

                    Capsule()
                        .fill(Color.hatchingBarGradient)
                        .frame(width: progress * 300, height: 12)  // 300 adalah lebar bar
                        .animation(.linear(duration: 0.1), value: progress)
                }
                .frame(width: 300)

                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.pennySecondaryText)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pennyBackground.ignoresSafeArea())
        .onReceive(timer) { _ in
            if progress < 1.0 {
                progress += 0.02  // Kecepatan menetas
            } else {
                timer.upstream.connect().cancel()
                // Alur: Selesai menetas, panggil onComplete untuk ke Home
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onComplete()
                }
            }
        }
    }

    @State private var isBouncing = false
}
