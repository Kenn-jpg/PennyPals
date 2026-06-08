//
//  HelpCenterView.swift
//  PennyPals
//

import SwiftUI

struct HelpCenterView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("How can we help you?")
                    .font(.title2.bold())
                    .foregroundColor(.pennyText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                VStack(spacing: 16) {
                    // MARK: - FAQ 1
                    faqCard(
                        question: "How do I hatch my pet?",
                        answer: "Simply set a savings goal and start saving! Once you make your first deposit, your egg will hatch into a surprise PennyPal."
                    )
                    
                    // MARK: - FAQ 2
                    faqCard(
                        question: "What happens if I miss a day?",
                        answer: "If you miss a day, your pet might become hungry or sad. Continuing to miss days could result in losing some XP, so keep your streak alive!"
                    )
                    
                    // MARK: - FAQ 3
                    faqCard(
                        question: "How do I buy accessories?",
                        answer: "Every time you save, you earn coins! Use these coins in the Shop tab to buy cute hats, glasses, and backgrounds for your pet."
                    )
                }
                .padding(.horizontal)

                Spacer(minLength: 40)
            }
            .padding(.top, 24)
        }
        .background(Color.pennyBackground.ignoresSafeArea())
        .navigationTitle("Help Center")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Komponen Reusable untuk FAQ Card
    private func faqCard(question: String, answer: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(question)
                .font(.headline)
                .foregroundColor(.pennyText)
            
            Text(answer)
                .font(.body)
                .foregroundColor(.pennySecondaryText)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    NavigationStack {
        HelpCenterView()
    }
}
