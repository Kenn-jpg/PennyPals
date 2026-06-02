//
//  SetNewGoalModal.swift
//  PennyPals
//
//  Created by Kelompok 8 on 02/06/26.
//

import SwiftUI

struct SetNewGoalModal: View {
    @Environment(\.dismiss) var dismiss

    var completedGoalName: String
    var onSave: (String, Double) -> Void

    @State private var itemName: String = ""
    @State private var targetAmountString: String = ""
    @State private var showConfetti: Bool = false

    // Konstanta Batas Maksimal (Rp 100 Juta)
    private let maxTargetLimit: Double = 100_000_000

    // Validasi form: nama tidak kosong dan nominal valid
    private var isFormValid: Bool {
        let cleanDigits = cleanNumericString(targetAmountString)
        guard let amount = Double(cleanDigits),
            amount > 0 && amount <= maxTargetLimit
        else {
            return false
        }
        return !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {

            // --- CELEBRATION HEADER ---
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#E8FFE8"),
                                    Color(hex: "#C8F7DC"),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 72, height: 72)
                        .scaleEffect(showConfetti ? 1.0 : 0.5)
                        .opacity(showConfetti ? 1.0 : 0.0)

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 36))
                        .foregroundColor(Color(hex: "#34C759"))
                        .scaleEffect(showConfetti ? 1.0 : 0.3)
                        .rotationEffect(.degrees(showConfetti ? 0 : -30))
                }

                Text("Goal Achieved! 🎉")
                    .font(.title3.bold())
                    .foregroundColor(.pennyText)

                Text("You completed \"\(completedGoalName)\"!")
                    .font(.subheadline)
                    .foregroundColor(.pennySecondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 32)
            .padding(.bottom, 20)
            .onAppear {
                withAnimation(
                    .spring(response: 0.6, dampingFraction: 0.6)
                        .delay(0.15)
                ) {
                    showConfetti = true
                }
            }

            // --- DIVIDER VISUAL ---
            HStack(spacing: 8) {
                Rectangle()
                    .fill(Color.pennySecondaryText.opacity(0.15))
                    .frame(height: 1)
                Text("SET NEW GOAL")
                    .font(.caption2.weight(.bold))
                    .foregroundColor(.pennySecondaryText)
                Rectangle()
                    .fill(Color.pennySecondaryText.opacity(0.15))
                    .frame(height: 1)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 20)

            // --- FORM AREA ---
            VStack(spacing: 16) {

                // 1. Input Nama Barang
                VStack(alignment: .leading, spacing: 6) {
                    Text("Item Name")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.pennySecondaryText)

                    HStack(spacing: 10) {
                        Image(systemName: "bag.fill")
                            .font(.body)
                            .foregroundColor(.pennyPurple)

                        TextField("e.g. PS5, iPhone, Laptop", text: $itemName)
                            .font(.body.weight(.medium))
                            .foregroundColor(.pennyText)
                            .autocorrectionDisabled()
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                // 2. Input Target Nominal
                VStack(alignment: .leading, spacing: 6) {
                    Text("Target Price")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.pennySecondaryText)

                    HStack(spacing: 10) {
                        Text("Rp")
                            .font(.headline.bold())
                            .foregroundColor(.pennyPurple)

                        TextField("5.000.000", text: $targetAmountString)
                            .keyboardType(.numberPad)
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.pennyText)
                            .onChange(of: targetAmountString) { _, newValue in
                                formatDynamicCurrency(newValue)
                            }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    // Pesan peringatan jika melebihi batas
                    let currentAmount =
                        Double(cleanNumericString(targetAmountString)) ?? 0
                    if currentAmount >= maxTargetLimit {
                        Text("⚠️ Batas maksimal target adalah Rp 100.000.000")
                            .font(.caption2)
                            .foregroundColor(.red.opacity(0.9))
                            .padding(.leading, 4)
                    }
                }

                // Preset Buttons untuk target populer
                HStack(spacing: 8) {
                    ForEach(
                        ["1000000", "5000000", "10000000", "50000000"],
                        id: \.self
                    ) { amount in
                        let formattedPreset = formatRawStringToDisplay(amount)
                        let isSelected =
                            cleanNumericString(targetAmountString) == amount

                        Button(action: {
                            withAnimation(.easeOut(duration: 0.2)) {
                                targetAmountString = formattedPreset
                            }
                        }) {
                            Text(formattedPreset)
                                .font(.caption2.weight(.semibold))
                                .frame(maxWidth: .infinity, minHeight: 36)
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
                                    RoundedRectangle(cornerRadius: 10)
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 32)

            Spacer().frame(height: 24)

            // --- SAVE BUTTON ---
            Button(action: {
                let cleanAmount = cleanNumericString(targetAmountString)
                if let amount = Double(cleanAmount) {
                    onSave(
                        itemName.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ),
                        amount
                    )
                }
                dismiss()
            }) {
                Text("Set New Goal 🎯")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PennyPrimaryButtonStyle())
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.5)
            .padding(.horizontal, 32)

            // --- SKIP BUTTON ---
            Button(action: {
                dismiss()
            }) {
                Text("Maybe Later")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.pennySecondaryText)
            }
            .padding(.top, 10)
            .padding(.bottom, 24)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    // --- HELPER LOGIC FUNCTIONS ---

    private func formatDynamicCurrency(_ input: String) {
        let digits = input.filter { $0.isNumber }
        if digits.isEmpty {
            targetAmountString = ""
            return
        }
        guard let doubleValue = Double(digits) else {
            targetAmountString = ""
            return
        }
        let finalValue = min(doubleValue, maxTargetLimit)
        if finalValue == 0 {
            targetAmountString = ""
            return
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."

        if let formatted = formatter.string(
            from: NSNumber(value: finalValue)
        ) {
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
