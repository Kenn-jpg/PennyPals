//
//  OnboardingScreen.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var onboardingVM = OnboardingViewModel()
    @Binding var rawAmount: String
    @Binding var selectedEgg: String
    var onStart: () -> Void

    let eggs = [
        ("rose", "Rosie", "#FFC9DE", "#FF94B8"),
        ("mint", "Sprout", "#B8EBD0", "#5FCB97"),
        ("sky", "Bloo", "#BFE0FF", "#5FA8E8"),
        ("sun", "Sunny", "#FFE3A8", "#F2B441"),
        ("lilac", "Vio", "#D9C8FF", "#9B7CFF"),
        ("peach", "Pip", "#FFD0B8", "#F2885F"),
    ]

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Let's set you up").font(.title.bold()).foregroundColor(
                    .pennyText
                )
                Text("A few quick steps to hatch your pal").font(.subheadline)
                    .foregroundColor(.pennySecondaryText)
            }.frame(maxWidth: .infinity, alignment: .leading).padding(
                .horizontal
            ).padding(.top, 20)

            VStack(alignment: .leading, spacing: 16) {
                Text("INITIAL SAVINGS").font(.caption.weight(.semibold))
                    .foregroundColor(.pennySecondaryText)
                HStack {
                    Text("Rp").font(.title2.bold()).foregroundColor(
                        .pennyPurple
                    )
                    TextField("500000", text: $rawAmount).keyboardType(
                        .numberPad
                    ).font(.largeTitle.bold()).foregroundColor(.pennyText)
                }
                HStack(spacing: 8) {
                    ForEach(
                        ["100000", "500000", "1000000", "5000000"],
                        id: \.self
                    ) { amount in
                        Button(action: { rawAmount = amount }) {
                            Text("\(Int(amount)! / 1000)k").font(
                                .subheadline.weight(.semibold)
                            ).frame(maxWidth: .infinity, minHeight: 44)
                                .background(
                                    rawAmount == amount
                                        ? Color.pennyPurple
                                        : Color(hex: "#F3F0FF")
                                ).foregroundColor(
                                    rawAmount == amount
                                        ? .white : .pennySecondaryText
                                ).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }.padding().background(Color(UIColor.systemBackground)).clipShape(
                RoundedRectangle(cornerRadius: 20)
            ).shadow(color: .black.opacity(0.05), radius: 10, y: 4).padding(
                .horizontal
            )

            VStack(alignment: .leading, spacing: 12) {
                Text("CHOOSE YOUR EGG").font(.caption.weight(.semibold))
                    .foregroundColor(.pennySecondaryText).padding(.horizontal)
                ScrollView(showsIndicators: false) {
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: 90), spacing: 12)
                        ],
                        spacing: 12
                    ) {
                        ForEach(eggs, id: \.0) { egg in
                            Button(action: { selectedEgg = egg.0 }) {
                                VStack(spacing: 8) {
                                    EggView(
                                        color: egg.2,
                                        spots: egg.3,
                                        size: 60
                                    )
                                    Text(egg.1).font(.caption.weight(.medium))
                                        .foregroundColor(.pennyText)
                                }.frame(maxWidth: .infinity, minHeight: 100)
                                    .background(Color(UIColor.systemBackground))
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 16)
                                    ).overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                selectedEgg == egg.0
                                                    ? Color.pennyPurple
                                                    : Color.clear,
                                                lineWidth: 2
                                            )
                                    )
                            }
                        }
                    }.padding(.horizontal).padding(.bottom, 8)
                }
            }

            Button(action: {
                Task {
                    let amount = Double(rawAmount) ?? 0
                    let petName =
                        eggs.first(where: { $0.0 == selectedEgg })?.1 ?? "Pal"
                    await onboardingVM.completeOnboarding(
                        initialSavings: amount,
                        eggType: selectedEgg,
                        petName: petName
                    )
                    onStart()
                }
            }) {
                Text("Start Saving →")
            }.buttonStyle(PennyPrimaryButtonStyle()).padding(.horizontal)
                .padding(.bottom, 16)
        }
        .background(Color.pennyBackground.ignoresSafeArea())
    }
}
