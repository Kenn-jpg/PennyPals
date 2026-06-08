//
//  AddSavingsModal.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

struct AddSavingsModal: View {
    @Environment(\.dismiss) var dismiss
    
    var currentTotalSavings: Double
    var onSave: (Double, Bool) -> Void

    @State private var amountString: String = ""
    // 2. Add State to differentiate between Savings and Expense
    @State private var isExpense: Bool = false

    // Maximum Input Limit Constant
    private let maxSavingsLimit: Double = 100_000_000

    // Form validation to control the save button status
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
            // 3. Add Segmented Picker to select transaction type
            Picker("Transaction Type", selection: $isExpense) {
                Text("Savings").tag(false)
                Text("Expense").tag(true)
            }
            .pickerStyle(.segmented)
            .padding(.top, 10)
            
            // Dynamic title based on selection
            Text(isExpense ? "Add Expense" : "Add Savings")
                .font(.title3.bold())
                .foregroundColor(.pennyText)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text("Rp")
                        .font(.headline.bold())
                        // The color of Rp changes to red if it is an expense
                        .foregroundColor(isExpense ? .red : .pennyPurple)

                    // Dynamic placeholder based on selection
                    TextField(isExpense ? "Expense Amount" : "Savings Amount", text: $amountString)
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

                // Warning message if it exceeds the limit or savings
                let currentAmount = Double(cleanNumericString(amountString)) ?? 0
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
                    // 4. Send amount data and expense status to HomeScreen
                    onSave(amount, isExpense)
                }
                dismiss()
            }) {
                // Dynamic button text based on selection
                Text(isExpense ? "Save Expense" : "Save Savings")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PennyPrimaryButtonStyle())
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.5)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 30)
        // Increased height slightly to 340 to accommodate the Segmented Picker above it
        .presentationDetents([.height(340)])
        .presentationDragIndicator(.visible)
    }

    // --- HELPER LOGIC FUNCTIONS ---

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

    private func cleanNumericString(_ input: String) -> String {
        return input.filter { $0.isNumber }
    }
}
