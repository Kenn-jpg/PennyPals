//
//  OnboardingScreen.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

// --- BEST PRACTICE: Buat struktur data khusus untuk opsi telur ---
struct EggOption {
    let id: String
    let name: String
    let assetName: String
}

struct OnboardingView: View {
    @StateObject private var onboardingVM = OnboardingViewModel()

    // 1. AKSES AUTH VIEW MODEL UNTUK LOGOUT PINTU KELUAR
    @EnvironmentObject var authVM: AuthViewModel

    @Binding var rawAmount: String
    @Binding var selectedEgg: String
    @Binding var wishlistName: String

    // --- TAMBAHAN BARU: Binding untuk target nominal wishlist ---
    @Binding var targetAmountString: String

    var onStart: () -> Void

    // --- DIUBAH: Menggunakan struct EggOption dan Asset Gambar ---
    let eggs: [EggOption] = [
        EggOption(id: "rose", name: "Rosie", assetName: "PinkEgg01"),
        EggOption(id: "mint", name: "Sprout", assetName: "GreenEgg01"),
        EggOption(id: "sky", name: "Bloo", assetName: "BlueEgg01"),
        EggOption(id: "sun", name: "Sunny", assetName: "YellowEgg01"),
        EggOption(id: "lilac", name: "Vio", assetName: "PurpleEgg01"),
        EggOption(id: "peach", name: "Pip", assetName: "PeachEgg01"),
    ]

    // Konstanta Batas Maksimal Tabungan (Rp 100 Juta)
    private let maxSavingsLimit: Double = 100_000_000

    // Validasi kelayakan form sebelum melanjutkan (Termasuk validasi Wishlist & Target Nominal)
    private var isFormValid: Bool {
        let cleanInitialDigits = cleanNumericString(rawAmount)
        let cleanTargetDigits = cleanNumericString(targetAmountString)

        guard let initialAmount = Double(cleanInitialDigits),
            initialAmount > 0 && initialAmount <= maxSavingsLimit
        else {
            return false
        }

        guard let targetAmount = Double(cleanTargetDigits),
            targetAmount > 0 && targetAmount <= maxSavingsLimit
        else {
            return false
        }

        // Tabungan awal tidak masuk akal jika melebihi target harga barang itu sendiri
        guard initialAmount <= targetAmount else {
            return false
        }

        // Form valid jika egg sudah dipilih, nama wishlist tidak kosong, dan target nominal valid
        return !selectedEgg.isEmpty
            && !wishlistName.trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
    }

    var body: some View {
        VStack(spacing: 16) {

            // --- TOP ACTION BAR (PINTU KELUAR LOGOUT) ---
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
            VStack(alignment: .leading, spacing: 6) {
                Text("Let's set you up")
                    .font(.title.bold())
                    .foregroundColor(.pennyText)
                Text("A few quick steps to hatch your pal")
                    .font(.subheadline)
                    .foregroundColor(.pennySecondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

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
                                    .system(
                                        size: 32,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                .foregroundColor(.pennyText)
                                .onChange(of: rawAmount) { _, newValue in
                                    formatDynamicCurrency(newValue)
                                }
                                .accessibilityIdentifier(
                                    "initialSavingsTextField"
                                )

                            Spacer()

                            // Ikon Pensil sebagai indikator visual bahwa input bisa di-custom sendiri
                            Image(systemName: "pencil.line")
                                .foregroundColor(
                                    .pennySecondaryText.opacity(0.7)
                                )
                                .font(.system(size: 18))
                        }

                        // Hint teks edukasi / Warning Limit Angka
                        let currentAmount =
                            Double(cleanNumericString(rawAmount)) ?? 0
                        if currentAmount >= maxSavingsLimit {
                            Text(
                                "⚠️ Batas maksimal tabungan awal adalah Rp 100.000.000"
                            )
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

                        // Tombol-tombol Preset Cepat (Sudah diubah ke format angka asli)
                        HStack(spacing: 8) {
                            ForEach(
                                ["100000", "500000", "1000000", "5000000"],
                                id: \.self
                            ) { amount in
                                let formattedPreset = formatRawStringToDisplay(
                                    amount
                                )
                                let isSelected =
                                    cleanNumericString(rawAmount) == amount

                                Button(action: {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        rawAmount = formattedPreset
                                    }
                                }) {
                                    Text(formattedPreset)
                                        .font(.caption.weight(.semibold))
                                        .frame(
                                            maxWidth: .infinity,
                                            minHeight: 44
                                        )
                                        .background(
                                            isSelected
                                                ? Color.pennyPurple
                                                : Color(hex: "#F3F0FF")
                                        )
                                        .foregroundColor(
                                            isSelected
                                                ? .white : .pennySecondaryText
                                        )
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 12)
                                        )
                                }
                                .accessibilityIdentifier(
                                    "presetButton_\(amount)"
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.05), radius: 10, y: 4)

                    // --- SECTION 2: WISHLIST GOAL & TARGET PRICE ---
                    VStack(alignment: .leading, spacing: 12) {
                        Text("YOUR FIRST WISHLIST GOAL")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.pennySecondaryText)

                        // 1. Input Nama Wishlist Barang (Teks dipersingkat)
                        HStack(spacing: 12) {
                            Image(systemName: "bag.fill")
                                .font(.body.bold())
                                .foregroundColor(.pennyPurple)

                            TextField(
                                "Nama barang (Contoh: Laptop)",
                                text: $wishlistName
                            )
                            .font(.body.weight(.medium))
                            .foregroundColor(.pennyText)
                            .autocorrectionDisabled()
                        }
                        .padding(.vertical, 4)

                        Divider()
                            .padding(.vertical, 2)

                        // 2. Input Target Nominal / Harga Barang (Teks dipersingkat)
                        HStack(spacing: 12) {
                            Image(systemName: "tag.fill")
                                .font(.body.bold())
                                .foregroundColor(.pennyPurple)

                            Text("Rp")
                                .font(.body.weight(.bold))
                                .foregroundColor(.pennyText)

                            TextField(
                                "Target harga nominal",
                                text: $targetAmountString
                            )
                            .keyboardType(.numberPad)
                            .font(.body.weight(.medium))
                            .foregroundColor(.pennyText)
                            .onChange(of: targetAmountString) { _, newValue in
                                formatDynamicTargetAmount(newValue)
                            }
                        }
                        .padding(.vertical, 4)

                        // Validasi Real-time: Cegah initial savings lebih besar dari target harga wishlist
                        let currentInitial =
                            Double(cleanNumericString(rawAmount)) ?? 0
                        let currentTarget =
                            Double(cleanNumericString(targetAmountString)) ?? 0

                        if currentTarget > 0 && currentInitial > currentTarget {
                            Text(
                                "⚠️ Tabungan awal tidak boleh melebihi harga target barang!"
                            )
                            .font(.caption2)
                            .foregroundColor(.red.opacity(0.9))
                            .padding(.top, 2)
                        } else {
                            Text(
                                "💡 Goal ini akan langsung muncul sebagai target utama di Home pagenya."
                            )
                            .font(.caption2)
                            .foregroundColor(.pennySecondaryText.opacity(0.8))
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.05), radius: 10, y: 4)

                    // --- SECTION 3: CHOOSE EGG ---
                    VStack(alignment: .leading, spacing: 12) {
                        Text("CHOOSE YOUR EGG")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.pennySecondaryText)
                            .padding(.horizontal, 4)

                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: 90), spacing: 12)
                            ],
                            spacing: 12
                        ) {
                            // --- DIUBAH: Menggunakan id dari struct EggOption ---
                            ForEach(eggs, id: \.id) { egg in
                                let isEggSelected = selectedEgg == egg.id

                                Button(action: {
                                    withAnimation(
                                        .spring(
                                            response: 0.3,
                                            dampingFraction: 0.6
                                        )
                                    ) {
                                        selectedEgg = egg.id
                                    }
                                }) {
                                    VStack(spacing: 8) {

                                        // --- DIUBAH: Menggunakan Image Asset ---
                                        Image(egg.assetName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .scaleEffect(
                                                isEggSelected ? 1.08 : 1.0
                                            )

                                        Text(egg.name)
                                            .font(.caption.weight(.medium))
                                            .foregroundColor(.pennyText)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 100)
                                    .background(Color(UIColor.systemBackground))
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 16)
                                    )
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
                                .accessibilityIdentifier("eggButton_\(egg.id)")
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }

            // --- BOTTOM ACTION BUTTON ---
            Button(action: {
                Task {
                    let cleanedAmountString = cleanNumericString(rawAmount)
                    let amount = Double(cleanedAmountString) ?? 0

                    let cleanedTargetString = cleanNumericString(
                        targetAmountString
                    )
                    let targetAmount = Double(cleanedTargetString) ?? 0

                    // --- DIUBAH: Pemanggilan id dan name menggunakan struct baru ---
                    let petName =
                        eggs.first(where: { $0.id == selectedEgg })?.name
                        ?? "Pal"

                    await onboardingVM.completeOnboarding(
                        initialSavings: amount,
                        targetAmount: targetAmount,
                        eggType: selectedEgg,
                        petName: petName,
                        wishlistName: wishlistName
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

    private func formatDynamicCurrency(_ input: String) {
        let digits = input.filter { $0.isNumber }
        if digits.isEmpty {
            rawAmount = ""
            return
        }
        guard let doubleValue = Double(digits) else {
            rawAmount = ""
            return
        }
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

    private func formatDynamicTargetAmount(_ input: String) {
        let digits = input.filter { $0.isNumber }
        if digits.isEmpty {
            targetAmountString = ""
            return
        }
        guard let doubleValue = Double(digits) else {
            targetAmountString = ""
            return
        }
        let finalValue = min(doubleValue, maxSavingsLimit)
        if finalValue == 0 {
            targetAmountString = ""
            return
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."

        if let formatted = formatter.string(from: NSNumber(value: finalValue)) {
            targetAmountString = formatted
        }
    }

    private func formatRawStringToDisplay(_ raw: String) -> String {
        guard let number = Int(raw) else { return raw }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: number)) ?? raw
    }

    private func cleanNumericString(_ input: String) -> String {
        return input.filter { $0.isNumber }
    }
}
