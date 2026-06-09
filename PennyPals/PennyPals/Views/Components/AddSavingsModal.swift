//
//  AddSavingsModal.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

/// Modal antarmuka (View) yang memungkinkan pengguna untuk mencatat transaksi baru, baik berupa penambahan tabungan (Savings) maupun pengeluaran (Expense).
struct AddSavingsModal: View {
    @Environment(\.dismiss) var dismiss

    /// Total saldo tabungan pengguna saat ini, digunakan untuk validasi agar pengeluaran tidak melebihi saldo.
    var currentTotalSavings: Double

    /// Closure yang dipanggil ketika pengguna berhasil menyimpan form.
    /// Mengirimkan dua nilai: nominal transaksi (Double) dan status pengeluaran (Bool - `true` jika pengeluaran).
    var onSave: (Double, Bool) -> Void

    @State private var amountString: String = ""

    /// Status pemilih (Picker) untuk menentukan jenis transaksi (false = Tabungan, true = Pengeluaran).
    @State private var isExpense: Bool = false

    /// Batas maksimal nominal uang yang dapat diinputkan dalam satu kali transaksi.
    private let maxSavingsLimit: Double = 100_000_000

    /// Validasi dinamis untuk menentukan apakah tombol simpan dapat ditekan atau tidak.
    private var isFormValid: Bool {
        let cleanDigits = cleanNumericString(amountString)
        guard let amount = Double(cleanDigits),
            amount > 0 && amount <= maxSavingsLimit
        else {
            return false
        }
        if isExpense && amount > currentTotalSavings {
            return false
        }
        return true
    }

    var body: some View {
        VStack(spacing: 20) {
            Picker("Transaction Type", selection: $isExpense) {
                Text("Savings").tag(false)
                Text("Expense").tag(true)
            }
            .pickerStyle(.segmented)
            .padding(.top, 10)

            Text(isExpense ? "Add Expense" : "Add Savings")
                .font(.title3.bold())
                .foregroundColor(.pennyText)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text("Rp")
                        .font(.headline.bold())
                        .foregroundColor(isExpense ? .red : .pennyPurple)

                    TextField(
                        isExpense ? "Expense Amount" : "Savings Amount",
                        text: $amountString
                    )
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

                let currentAmount =
                    Double(cleanNumericString(amountString)) ?? 0
                if isExpense && currentAmount > currentTotalSavings {
                    Text("⚠️ Saldo tabungan tidak mencukupi!")
                        .font(.caption2)
                        .foregroundColor(.red.opacity(0.9))
                        .padding(.leading, 4)
                } else if currentAmount >= maxSavingsLimit {
                    Text("⚠️ Maximum input limit is Rp 100,000,000")
                        .font(.caption2)
                        .foregroundColor(.red.opacity(0.9))
                        .padding(.leading, 4)
                }
            }

            Button(action: {
                let cleanAmount = cleanNumericString(amountString)
                if let amount = Double(cleanAmount) {
                    onSave(amount, isExpense)
                }
                dismiss()
            }) {
                Text(isExpense ? "Save Expense" : "Save Savings")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PennyPrimaryButtonStyle())
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.5)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 30)
        .presentationDetents([.height(340)])
        .presentationDragIndicator(.visible)
    }

    /// Memformat teks input pengguna menjadi format mata uang dengan pemisah ribuan (titik) secara *real-time*.
    private func formatDynamicCurrency(_ input: String) {
        let digits = input.filter { $0.isNumber }

        if digits.isEmpty {
            amountString = ""
            return
        }

        guard let doubleValue = Double(digits) else {
            amountString = ""
            return
        }

        let finalValue = min(doubleValue, maxSavingsLimit)
        if finalValue == 0 {
            amountString = ""
            return
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."

        if let formatted = formatter.string(from: NSNumber(value: finalValue)) {
            amountString = formatted
        }
    }

    /// Menghapus karakter non-numerik dari teks (seperti titik pemisah ribuan) untuk keperluan kalkulasi matematis.
    private func cleanNumericString(_ input: String) -> String {
        return input.filter { $0.isNumber }
    }
}
