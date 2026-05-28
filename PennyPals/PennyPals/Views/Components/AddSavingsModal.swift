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

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Savings").font(.headline)

            TextField("Nominal Tabungan (Rp)", text: $amountString)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Button("Simpan Tabungan") {
                if let amount = Double(amountString) {
                    onSave(amount)
                }
                dismiss()
            }
            .buttonStyle(PennyPrimaryButtonStyle())
        }
        .padding(40)
        .presentationDetents([.height(250)])
    }
}
