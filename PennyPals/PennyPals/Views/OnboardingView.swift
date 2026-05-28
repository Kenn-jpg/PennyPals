//
//  OnboardingScreen.swift
//  PennyPals
//
//  Created by student on 28/05/26.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var rawAmount: String
    @Binding var selectedEgg: String
    var onStart: () -> Void
    
    let eggs = [
        ("rose", "Rosie", "#FFC9DE", "#FF94B8"), ("mint", "Sprout", "#B8EBD0", "#5FCB97"),
        ("sky", "Bloo", "#BFE0FF", "#5FA8E8"), ("sun", "Sunny", "#FFE3A8", "#F2B441"),
        ("lilac", "Vio", "#D9C8FF", "#9B7CFF"), ("peach", "Pip", "#FFD0B8", "#F2885F")
    ]
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return Int(rawAmount).map { formatter.string(from: NSNumber(value: $0)) ?? rawAmount } ?? "0"
    }
    
    let columns = [GridItem(.adaptive(minimum: 90), spacing: 12)]
    
    var body: some View {
        VStack(spacing: 20) {
            // Header (Statis - Tidak Ikut Tergeser)
            VStack(alignment: .leading, spacing: 8) {
                Text("Let's set you up")
                    .font(.title.bold())
                    .foregroundColor(.pennyText)
                
                Text("A few quick steps to hatch your pal")
                    .font(.subheadline)
                    .foregroundColor(.pennySecondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 20)
            
            // Box Input Tabungan (Statis - Tidak Ikut Tergeser)
            VStack(alignment: .leading, spacing: 16) {
                Text("INITIAL SAVINGS")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.pennySecondaryText)
                
                HStack(alignment: .firstTextBaseline) {
                    Text("Rp").font(.title2.bold()).foregroundColor(.pennyPurple)
                    TextField("500.000", text: Binding(
                        get: { formattedAmount },
                        set: { rawAmount = $0.filter { $0.isNumber } }
                    ))
                    .keyboardType(.numberPad)
                    .font(.largeTitle.bold())
                    .foregroundColor(.pennyText)
                }
                
                HStack(spacing: 8) {
                    ForEach(["100000", "500000", "1000000", "5000000"], id: \.self) { amount in
                        Button(action: { rawAmount = amount }) {
                            Text("\(Int(amount)! / 1000)k")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(rawAmount == amount ? Color.pennyPurple : Color(hex: "#F3F0FF"))
                                .foregroundColor(rawAmount == amount ? .white : .pennySecondaryText)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
            .padding(.horizontal)
            
            // Bagian Pilihan Telur (Hanya Grid di dalam ScrollView ini yang bisa di-scroll)
            VStack(alignment: .leading, spacing: 12) {
                Text("CHOOSE YOUR EGG")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.pennySecondaryText)
                    .padding(.horizontal)
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(eggs, id: \.0) { egg in
                            Button(action: { selectedEgg = egg.0 }) {
                                VStack(spacing: 8) {
                                    EggView(color: egg.2, spots: egg.3, size: 60)
                                    Text(egg.1)
                                        .font(.caption.weight(.medium))
                                        .foregroundColor(.pennyText)
                                }
                                .frame(maxWidth: .infinity, minHeight: 100)
                                .background(Color(UIColor.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(selectedEgg == egg.0 ? Color.pennyPurple : Color.clear, lineWidth: 2)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
            }
            
            // Tombol Mulai (Statis menempel di posisi paling bawah layar)
            Button("Start Saving →", action: onStart)
                .buttonStyle(PennyPrimaryButtonStyle())
                .padding(.horizontal)
                .padding(.bottom, 16)
        }
        .background(Color.pennyBackground.ignoresSafeArea())
    }
}
