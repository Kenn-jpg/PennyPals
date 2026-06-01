//
//  HatchingView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI
internal import Combine

struct HatchingView: View {
    var eggId: String
    var onComplete: () -> Void
    @State private var progress: Double = 0.0
    @State private var isBouncing = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            ZStack {
                EggView(color: "#FFC9DE", spots: "#FF94B8", size: 120).offset(
                    y: isBouncing ? -10 : 10
                )
            }.frame(height: 150).onAppear {
                withAnimation(
                    .easeInOut(duration: 1.0).repeatForever(autoreverses: true)
                ) { isBouncing = true }
            }

            VStack(spacing: 16) {
                Text("Hatching...").font(.headline).foregroundColor(.pennyText)
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(UIColor.secondarySystemBackground))
                        .frame(height: 12)
                    Capsule().fill(Color.hatchingBarGradient).frame(
                        width: progress * 300,
                        height: 12
                    ).animation(.linear(duration: 0.1), value: progress)
                }.frame(width: 300)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity).background(
            Color.pennyBackground.ignoresSafeArea()
        )
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
