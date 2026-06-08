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
                    FAQCardView(
                        question: "1. How do I hatch my pet?",
                        answer: "Simply set a savings goal and start saving! Once you make your first deposit, your egg will hatch into a surprise PennyPal."
                    )
                    
                    // MARK: - FAQ 2
                    FAQCardView(
                        question: "2. What happens if I miss a day?",
                        answer: "If you miss a day, your pet might become hungry or sad. Continuing to miss days could result in losing some XP, so keep your streak alive!"
                    )
                    
                    // MARK: - FAQ 3
                    FAQCardView(
                        question: "3. How do I buy accessories?",
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

}

// MARK: - FAQ Card Component
struct FAQCardView: View {
    let question: String
    let answer: String
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(question)
                        .font(.headline)
                        .foregroundColor(.pennyText)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.pennyPurple)
                        .fontWeight(.semibold)
                }
                .contentShape(Rectangle()) // Make the whole row tappable
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Text(answer)
                    .font(.body)
                    .foregroundColor(.pennySecondaryText)
                    .lineSpacing(4)
                    .padding(.top, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
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
