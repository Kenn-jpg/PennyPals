//
//  HelpCenterView.swift
//  PennyPals
//

import SwiftUI

struct HelpCenterView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("How can we help you?")
                    .font(.title2.bold())
                    .foregroundColor(.pennyText)
                    .padding(.bottom, 8)

                // MARK: - FAQ 1
                VStack(alignment: .leading, spacing: 8) {
                    Text("How do I hatch my pet?")
                        .font(.headline)
                        .foregroundColor(.pennyText)
                    Text("Simply set a savings goal and start saving! Once you make your first deposit, your egg will hatch into a surprise PennyPal.")
                        .font(.body)
                        .foregroundColor(.pennySecondaryText)
                }

                // MARK: - FAQ 2
                VStack(alignment: .leading, spacing: 8) {
                    Text("What happens if I miss a day?")
                        .font(.headline)
                        .foregroundColor(.pennyText)
                    Text("If you miss a day, your pet might become hungry or sad. Continuing to miss days could result in losing some XP, so keep your streak alive!")
                        .font(.body)
                        .foregroundColor(.pennySecondaryText)
                }

                // MARK: - FAQ 3
                VStack(alignment: .leading, spacing: 8) {
                    Text("How do I buy accessories?")
                        .font(.headline)
                        .foregroundColor(.pennyText)
                    Text("Every time you save, you earn coins! Use these coins in the Shop tab to buy cute hats, glasses, and backgrounds for your pet.")
                        .font(.body)
                        .foregroundColor(.pennySecondaryText)
                }

                Spacer()
            }
            .padding()
        }
        .background(Color.pennyBackground.ignoresSafeArea())
        .navigationTitle("Help Center")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HelpCenterView()
    }
}
