//
//  SetNewGoalModal.swift
//  PennyPals
//
//  Created by Kelompok 8 on 02/06/26.
//

import SwiftUI

/// Modal antarmuka yang muncul untuk merayakan pencapaian target sebelumnya dan mendorong pengguna menentukan target (Wishlist) baru.
struct SetNewGoalModal: View {
    @Environment(\.dismiss) var dismiss

    /// Nama target yang baru saja berhasil diselesaikan oleh pengguna.
    var completedGoalName: String

    /// Closure yang dipanggil saat target baru berhasil disimpan, mengirimkan nama barang (String) dan nominal (Double).
    var onSave: (String, Double) -> Void

    @State private var itemName: String = ""
    @State private var targetAmountString: String = ""
    @State private var showConfetti: Bool = false

    /// Batas maksimal nominal uang yang dapat diatur sebagai target tabungan baru.
    private let maxTargetLimit: Double = 100_000_000

    /// Properti terhitung yang memastikan field nama tidak kosong dan nominal berada pada rentang yang diizinkan.
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

            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#34C759").opacity(0.15))
                        .frame(width: 88, height: 88)
                        .scaleEffect(showConfetti ? 1.0 : 0.6)
                        .opacity(showConfetti ? 1.0 : 0.0)

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
                        .font(.system(size: 38, weight: .semibold))
                        .foregroundColor(Color(hex: "#34C759"))
                        .scaleEffect(showConfetti ? 1.0 : 0.3)
                        .rotationEffect(.degrees(showConfetti ? 0 : -30))
                }

                VStack(spacing: 6) {
                    Text("Goal Achieved! 🎉")
                        .font(.title2.bold())
                        .foregroundColor(.pennyText)

                    Text("You completed \"\(completedGoalName)\"!")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.pennySecondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.top, 32)
            .padding(.bottom, 24)
            .onAppear {
                withAnimation(
                    .spring(response: 0.6, dampingFraction: 0.6)
                        .delay(0.15)
                ) {
                    showConfetti = true
                }
            }

            HStack(spacing: 12) {
                Rectangle()
                    .fill(Color.pennySecondaryText.opacity(0.15))
                    .frame(height: 1)
                Text("SET NEW GOAL")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.pennySecondaryText.opacity(0.8))
                    .tracking(1)
                Rectangle()
                    .fill(Color.pennySecondaryText.opacity(0.15))
                    .frame(height: 1)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 24)

            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Item Name")
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.pennySecondaryText)

                    HStack(spacing: 12) {
                        Image(systemName: "bag.fill")
                            .font(.body)
                            .foregroundColor(.pennyPurple)

                        TextField("What are you saving for?", text: $itemName)
                            .font(.body.weight(.medium))
                            .foregroundColor(.pennyText)
                            .autocorrectionDisabled()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(
                        color: Color.black.opacity(0.03),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                Color.pennyPurple.opacity(0.12),
                                lineWidth: 1
                            )
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Target Price")
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.pennySecondaryText)

                    HStack(spacing: 12) {
                        Text("Rp")
                            .font(.headline.bold())
                            .foregroundColor(.pennyPurple)

                        TextField("5.000.000", text: $targetAmountString)
                            .keyboardType(.numberPad)
                            .font(.title3.weight(.bold))
                            .foregroundColor(.pennyText)
                            .onChange(of: targetAmountString) { _, newValue in
                                formatDynamicCurrency(newValue)
                            }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(
                        color: Color.black.opacity(0.03),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                Color.pennyPurple.opacity(0.12),
                                lineWidth: 1
                            )
                    )

                    let currentAmount =
                        Double(cleanNumericString(targetAmountString)) ?? 0
                    if currentAmount >= maxTargetLimit {
                        Label(
                            "Batas maksimal target adalah Rp 100.000.000",
                            systemImage: "exclamationmark.triangle.fill"
                        )
                        .font(.caption2.weight(.medium))
                        .foregroundColor(.red.opacity(0.9))
                        .padding(.leading, 4)
                        .padding(.top, 2)
                    }
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            VStack(spacing: 12) {
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
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PennyPrimaryButtonStyle())
                .disabled(!isFormValid)
                .opacity(isFormValid ? 1.0 : 0.5)

                Button(action: {
                    dismiss()
                }) {
                    Text("Maybe Later")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.pennySecondaryText)
                        .padding(.vertical, 4)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 24)
        }
        .background(Color.pennyBackground.ignoresSafeArea())
        .presentationDetents([.fraction(0.65)])
        .presentationDragIndicator(.visible)
    }

    /// Memformat input nominal harga target menjadi format uang yang nyaman dibaca (dengan titik) secara *real-time*.
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

        if let formatted = formatter.string(from: NSNumber(value: finalValue)) {
            targetAmountString = formatted
        }
    }

    /// Membersihkan *string* dari karakter selain angka agar bisa dikonversi menjadi tipe data `Double`.
    private func cleanNumericString(_ input: String) -> String {
        return input.filter { $0.isNumber }
    }
}
