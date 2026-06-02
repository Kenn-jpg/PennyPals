//
//  AddSavingsModal.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

struct AddSavingsModal: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (Double) -> Void

    @State private var amountString: String = ""

    // Konstanta Batas Maksimal Input Tabungan
    private let maxSavingsLimit: Double = 100_000_000

    // Validasi form untuk mengontrol status tombol simpan
    private var isFormValid: Bool {
        let cleanDigits = cleanNumericString(amountString)
        guard let amount = Double(cleanDigits),
            amount > 0 && amount <= maxSavingsLimit
        else {
            return false
        }
        return true
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Add Savings")
                .font(.title3.bold())
                .foregroundColor(.pennyText)

            VStack(alignment: .leading, spacing: 8) {
                // Input form dengan style yang konsisten
                HStack(spacing: 8) {
                    Text("Rp")
                        .font(.headline.bold())
                        .foregroundColor(.pennyPurple)

                    TextField("Nominal Tabungan", text: $amountString)
                        .keyboardType(.numberPad)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.pennyText)
                        .onChange(of: amountString) { _, newValue in
                            formatDynamicCurrency(newValue)
                        }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Pesan Peringatan jika melebihi batas
                let currentAmount =
                    Double(cleanNumericString(amountString)) ?? 0
                if currentAmount >= maxSavingsLimit {
                    Text("⚠️ Batas maksimal input adalah Rp 100.000.000")
                        .font(.caption2)
                        .foregroundColor(.red.opacity(0.9))
                        .padding(.leading, 4)
                }
            }

            Button(action: {
                let cleanAmount = cleanNumericString(amountString)
                if let amount = Double(cleanAmount) {
                    onSave(amount)
                }
                dismiss()
            }) {
                Text("Simpan Tabungan")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PennyPrimaryButtonStyle())
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.5)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 40)
        // Menyesuaikan tinggi agar muat dengan teks peringatan
        .presentationDetents([.height(280)])
        .presentationDragIndicator(.visible)
    }

    // --- HELPER LOGIC FUNCTIONS ---

    private func formatDynamicCurrency(_ input: String) {
        // Hanya ambil digit angka
        let digits = input.filter { $0.isNumber }

        if digits.isEmpty {
            amountString = ""
            return
        }

        guard let doubleValue = Double(digits) else {
            amountString = ""
            return
        }

        // Batasi nilai yang dimasukkan agar tidak melebihi limit
        let finalValue = min(doubleValue, maxSavingsLimit)
        if finalValue == 0 {
            amountString = ""
            return
        }

        // Format angka dengan separator titik
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."

        if let formatted = formatter.string(from: NSNumber(value: finalValue)) {
            amountString = formatted
        }
    }

    private func cleanNumericString(_ input: String) -> String {
        return input.filter { $0.isNumber }
    }
}
