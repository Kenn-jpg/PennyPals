//
//  OnboardingScreen.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var onboardingVM = OnboardingViewModel()

    // 1. AKSES AUTH VIEW MODEL UNTUK LOGOUT PINTU KELUAR
    @EnvironmentObject var authVM: AuthViewModel

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

    // Konstanta Batas Maksimal Tabungan (Rp 100 Juta)
    private let maxSavingsLimit: Double = 100_000_000

    // Validasi kelayakan form sebelum melanjutkan
    private var isFormValid: Bool {
        let cleanDigits = cleanNumericString(rawAmount)
        guard let amount = Double(cleanDigits),
            amount > 0 && amount <= maxSavingsLimit
        else {
            return false
        }
        return !selectedEgg.isEmpty
    }

    var body: some View {
        VStack(spacing: 20) {

            // --- 2. TOP ACTION BAR (PINTU KELUAR LOGOUT) ---
            HStack {
                Spacer()
                Button(action: {
                    authVM.logout()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Log Out")
                    }
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.red.opacity(0.8))
                }
                .padding(.horizontal)
                .padding(.top, 12)
            }

            // --- HEADER TITLE ---
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

            // --- SECTION 1: INITIAL SAVINGS ---
            VStack(alignment: .leading, spacing: 14) {
                Text("INITIAL SAVINGS")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.pennySecondaryText)

                // Input Lapisan Utama dengan UX Signifier
                HStack(spacing: 8) {
                    Text("Rp")
                        .font(.title2.bold())
                        .foregroundColor(.pennyPurple)

                    TextField("500.000", text: $rawAmount)
                        .keyboardType(.numberPad)
                        .font(
                            .system(size: 32, weight: .bold, design: .rounded)
                        )
                        .foregroundColor(.pennyText)
                        .onChange(of: rawAmount) { _, newValue in
                            formatDynamicCurrency(newValue)
                        }
                        .accessibilityIdentifier("initialSavingsTextField")

                    Spacer()

                    // Ikon Pensil sebagai indikator visual bahwa input bisa di-custom sendiri
                    Image(systemName: "pencil.line")
                        .foregroundColor(.pennySecondaryText.opacity(0.7))
                        .font(.system(size: 18))
                }

                // Hint teks edukasi / Warning Limit Angka
                let currentAmount = Double(cleanNumericString(rawAmount)) ?? 0
                if currentAmount >= maxSavingsLimit {
                    Text("⚠️ Batas maksimal tabungan awal adalah Rp 100.000.000")
                        .font(.caption2)
                        .foregroundColor(.red.opacity(0.9))
                        .padding(.top, -4)
                } else {
                    Text(
                        "💡 Tip: Kamu bisa mengetik langsung nominal tabunganmu di atas."
                    )
                    .font(.caption2)
                    .foregroundColor(.pennySecondaryText.opacity(0.8))
                    .padding(.top, -4)
                }

                // Tombol-tombol Preset Cepat
                HStack(spacing: 8) {
                    ForEach(
                        ["100000", "500000", "1000000", "5000000"],
                        id: \.self
                    ) { amount in
                        let formattedPreset = formatRawStringToDisplay(amount)
                        let isSelected = cleanNumericString(rawAmount) == amount

                        Button(action: {
                            withAnimation(.easeOut(duration: 0.2)) {
                                rawAmount = formattedPreset
                            }
                        }) {
                            Text("\(Int(amount)! / 1000)k")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(
                                    isSelected
                                        ? Color.pennyPurple
                                        : Color(hex: "#F3F0FF")
                                )
                                .foregroundColor(
                                    isSelected ? .white : .pennySecondaryText
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .accessibilityIdentifier("presetButton_\(amount)")
                    }
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
            .padding(.horizontal)

            // --- SECTION 2: CHOOSE EGG ---
            VStack(alignment: .leading, spacing: 12) {
                Text("CHOOSE YOUR EGG")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.pennySecondaryText)
                    .padding(.horizontal)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: 90), spacing: 12)
                        ],
                        spacing: 12
                    ) {
                        ForEach(eggs, id: \.0) { egg in
                            let isEggSelected = selectedEgg == egg.0

                            Button(action: {
                                withAnimation(
                                    .spring(response: 0.3, dampingFraction: 0.6)
                                ) {
                                    selectedEgg = egg.0
                                }
                            }) {
                                VStack(spacing: 8) {
                                    EggView(
                                        color: egg.2,
                                        spots: egg.3,
                                        size: 60
                                    )
                                    .scaleEffect(isEggSelected ? 1.08 : 1.0)

                                    Text(egg.1)
                                        .font(.caption.weight(.medium))
                                        .foregroundColor(.pennyText)
                                }
                                .frame(maxWidth: .infinity, minHeight: 100)
                                .background(Color(UIColor.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            isEggSelected
                                                ? Color.pennyPurple
                                                : Color.clear,
                                            lineWidth: 2.5
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("eggButton_\(egg.0)")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
            }

            // --- BOTTOM ACTION BUTTON ---
            Button(action: {
                Task {
                    let cleanedAmountString = cleanNumericString(rawAmount)
                    let amount = Double(cleanedAmountString) ?? 0

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
            }
            .buttonStyle(PennyPrimaryButtonStyle())
            .padding(.horizontal)
            .padding(.bottom, 16)
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.5)
            .accessibilityIdentifier("startSavingSubmitButton")
        }
        .background(Color.pennyBackground.ignoresSafeArea())
    }

    // --- HELPER LOGIC FUNCTIONS ---

    /// Memformat string input secara real-time dengan pemisah ribuan titik (.) & Safe Guard Limit
    private func formatDynamicCurrency(_ input: String) {
        let digits = input.filter { $0.isNumber }

        if digits.isEmpty {
            rawAmount = ""
            return
        }

        // Menggunakan Double terlebih dahulu untuk mencegah crash Int overflow jika input terlalu ekstrem
        guard let doubleValue = Double(digits) else {
            rawAmount = ""
            return
        }

        // Capping value: mengunci angka di angka maksimal jika melampaui limit
        let finalValue = min(doubleValue, maxSavingsLimit)

        if finalValue == 0 {
            rawAmount = ""
            return
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."

        if let formatted = formatter.string(from: NSNumber(value: finalValue)) {
            rawAmount = formatted
        }
    }

    /// Mengubah string mentah angka menjadi format tampilan bertitik
    private func formatRawStringToDisplay(_ raw: String) -> String {
        guard let number = Int(raw) else { return raw }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: number)) ?? raw
    }

    /// Menghapus semua karakter pemisah titik
    private func cleanNumericString(_ input: String) -> String {
        return input.filter { $0.isNumber }
    }
}
