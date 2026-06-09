//
//  OnboardingView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

// MARK: - 1. Models

struct EggOption {
    let id: String
    let name: String
    let assetName: String
}

// MARK: - 2. Main View

struct OnboardingView: View {

    // MARK: - 3. Properties

    @StateObject private var onboardingVM = OnboardingViewModel()
    @EnvironmentObject var authVM: AuthViewModel

    @State private var petNameInput: String = ""
    @Binding var rawAmount: String
    @Binding var selectedEgg: String
    @Binding var wishlistName: String
    @Binding var targetAmountString: String

    var onStart: () -> Void

    let eggs: [EggOption] = [
        EggOption(id: "rose", name: "Rosie", assetName: "PinkEgg01"),
        EggOption(id: "mint", name: "Sprout", assetName: "GreenEgg01"),
        EggOption(id: "sky", name: "Bloo", assetName: "BlueEgg01"),
        EggOption(id: "sun", name: "Sunny", assetName: "YellowEgg01"),
        EggOption(id: "lilac", name: "Vio", assetName: "PurpleEgg01"),
        EggOption(id: "peach", name: "Pip", assetName: "PeachEgg01"),
    ]

    private let availablePets = ["Cat", "Dog", "Owl", "Pig", "Raccoon", "Seal"]

    private let maxSavingsLimit: Double = 100_000_000

    // MARK: - 4. Formatters

    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter
    }()

    // MARK: - 5. Computed Properties

    private var isFormValid: Bool {
        let initialAmount = Double(cleanNumericString(rawAmount)) ?? 0
        let targetAmount = Double(cleanNumericString(targetAmountString)) ?? 0

        guard initialAmount >= 0, initialAmount <= maxSavingsLimit,
              targetAmount > 0, targetAmount <= maxSavingsLimit,
              initialAmount < targetAmount
        else { return false }

        return !selectedEgg.isEmpty
            && !wishlistName.trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
            && !petNameInput.trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
    }

    // MARK: - 6. Body

    var body: some View {
        VStack(spacing: 0) {

            // Top Action Bar
            HStack {
                Spacer()
                Button(action: { authVM.logout() }) {
                    Text("Log Out")
                        .font(.footnote.weight(.medium))
                        .foregroundColor(.red.opacity(0.8))
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }

            // Header Title
            VStack(alignment: .leading, spacing: 4) {
                Text("Let's set you up")
                    .font(.largeTitle.bold())
                    .foregroundColor(.pennyText)
                Text("A few quick steps to hatch your pal")
                    .font(.body)
                    .foregroundColor(.pennySecondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {

                    // Section 1: Initial Savings
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "INITIAL SAVINGS")

                        HStack(alignment: .bottom, spacing: 8) {
                            Text("Rp")
                                .font(.title3.bold())
                                .foregroundColor(.pennySecondaryText)
                                .padding(.bottom, 4)

                            TextField("0", text: $rawAmount)
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
                                    rawAmount = formatCurrencyInput(newValue)
                                }
                        }

                        Divider()

                        let currentAmount = Double(cleanNumericString(rawAmount)) ?? 0
                        if currentAmount >= maxSavingsLimit {
                            HintText(
                                icon: "exclamationmark.triangle.fill",
                                text: "Batas maksimal tabungan awal adalah Rp 100.000.000",
                                isWarning: true
                            )
                        }

                        // MARK: - Presets
                        HStack(spacing: 8) {
                            ForEach(
                                ["100000", "500000", "1000000", "5000000"],
                                id: \.self
                            ) { amount in
                                let formattedPreset = formatCurrencyInput(amount)
                                let isSelected = cleanNumericString(rawAmount) == amount

                                Button(action: {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        rawAmount = formattedPreset
                                    }
                                }) {
                                    Text(formattedPreset)
                                        .font(.caption.weight(.medium))
                                        .frame(
                                            maxWidth: .infinity,
                                            minHeight: 36
                                        )
                                        .background(
                                            isSelected
                                                ? Color.pennyPurple
                                                : Color.gray.opacity(0.1)
                                        )
                                        .foregroundColor(
                                            isSelected ? .white : .pennyText
                                        )
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.top, 4)
                    }

                    // Section 2: Wishlist Goal & Target Price
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: "YOUR FIRST WISHLIST GOAL")

                        VStack(spacing: 0) {
                            MinimalTextField(
                                icon: "bag",
                                placeholder: "Nama barang (Contoh: Laptop)",
                                text: $wishlistName
                            )
                            Divider().padding(.leading, 32)
                            MinimalTextField(
                                icon: "tag",
                                placeholder: "Target harga nominal (Rp)",
                                text: $targetAmountString,
                                isNumeric: true
                            )
                            .onChange(of: targetAmountString) { _, newValue in
                                targetAmountString = formatCurrencyInput(newValue)
                            }
                        }
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)

                        // MARK: - Validation Warnings
                        let currentInitial = Double(cleanNumericString(rawAmount)) ?? 0
                        let currentTarget = Double(cleanNumericString(targetAmountString)) ?? 0

                        if currentTarget > 0 && currentInitial >= currentTarget {
                            HintText(
                                icon: "exclamationmark.triangle.fill",
                                text: "Tabungan awal tidak boleh melebihi harga target barang!",
                                isWarning: true
                            )
                        }
                    }

                    // Section 3: Pet Name
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "YOUR PET NAME")

                        MinimalTextField(
                            icon: "pawprint",
                            placeholder: "Nama pet kamu (Contoh: Mochi)",
                            text: $petNameInput
                        )
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                    }

                    // Section 4: Choose Egg
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: "CHOOSE YOUR EGG")

                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: 90), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(eggs, id: \.id) { egg in
                                let isSelected = selectedEgg == egg.id

                                Button(action: {
                                    withAnimation(
                                        .spring(
                                            response: 0.3,
                                            dampingFraction: 0.6
                                        )
                                    ) { selectedEgg = egg.id }
                                }) {
                                    VStack(spacing: 8) {
                                        Image(egg.assetName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .scaleEffect(isSelected ? 1.1 : 1.0)
                                            .opacity(
                                                selectedEgg.isEmpty
                                                    || isSelected ? 1.0 : 0.5
                                            )

                                        Text(egg.name)
                                            .font(
                                                .caption.weight(
                                                    isSelected
                                                        ? .bold : .regular
                                                )
                                            )
                                            .foregroundColor(
                                                isSelected
                                                    ? .pennyPurple
                                                    : .pennySecondaryText
                                            )
                                    }
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        isSelected
                                            ? Color.pennyPurple.opacity(0.1)
                                            : Color.clear
                                    )
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                isSelected
                                                    ? Color.pennyPurple
                                                    : Color.gray.opacity(0.2),
                                                lineWidth: isSelected ? 2 : 1
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }

            // MARK: - Bottom Action Button
            Button(action: {
                Task {
                    let amount = Double(cleanNumericString(rawAmount)) ?? 0
                    let targetAmount = Double(cleanNumericString(targetAmountString)) ?? 0
                    let petName = petNameInput.trimmingCharacters(in: .whitespacesAndNewlines)

                    // Mengacak ras pet sebelum disimpan (Gacha)
                    let randomlyHatchedPet = availablePets.randomElement() ?? "Cat"

                    await onboardingVM.completeOnboarding(
                        initialSavings: amount,
                        targetAmount: targetAmount,
                        eggType: selectedEgg,
                        petName: petName,
                        wishlistName: wishlistName,
                        petType: randomlyHatchedPet
                    )
                    onStart()
                }
            }) {
                Text("Start Saving →")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PennyPrimaryButtonStyle())
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .padding(.top, 8)
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.5)
        }
        .background(Color.pennyBackground.ignoresSafeArea())
    }

    // MARK: - 7. Helper Methods

    private func formatCurrencyInput(_ input: String) -> String {
        let digits = cleanNumericString(input)
        guard let doubleValue = Double(digits) else { return "" }
        let finalValue = min(doubleValue, maxSavingsLimit)

        return Self.currencyFormatter.string(from: NSNumber(value: finalValue)) ?? ""
    }

    private func cleanNumericString(_ input: String) -> String {
        return input.filter { $0.isNumber }
    }
}

// MARK: - 8. UI Components

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.caption.weight(.bold))
            .foregroundColor(.gray)
            .kerning(1.2)
    }
}

struct HintText: View {
    let icon: String
    let text: String
    var isWarning: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption2)
        .foregroundColor(isWarning ? .red : .gray)
    }
}

struct MinimalTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isNumeric: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)

            TextField(placeholder, text: $text)
                .font(.body.weight(.medium))
                .foregroundColor(.pennyText)
                .keyboardType(isNumeric ? .numberPad : .default)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
