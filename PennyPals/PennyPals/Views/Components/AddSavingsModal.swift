//
//  AddSavingsModal.swift
//  PennyPals
//
//  Created by student on 28/05/26.
//


import SwiftUI

struct AddSavingsModal: View {
    @Environment(\.dismiss) var dismiss
    var onSave: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add Savings").font(.headline)
            Text("Simulate adding a deposit to make the pet happy.")
                .font(.subheadline).foregroundColor(.pennySecondaryText).multilineTextAlignment(.center)
            
            Button("Simulate Deposit") {
                onSave() // Panggil trigger di HomeView
                dismiss() // Tutup modal
            }
            .buttonStyle(PennyPrimaryButtonStyle())
        }
        .padding(40)
        .presentationDetents([.height(250)]) // Native bottom sheet HIG
    }
}