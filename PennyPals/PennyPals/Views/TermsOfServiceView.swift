//
//  TermsOfServiceView.swift
//  PennyPals
//

import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("Terms of Service")
                        .font(.title2.bold())
                        .foregroundColor(.pennyText)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Last updated: June 2026")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)

                VStack(spacing: 16) {
                    termsCard(
                        title: "1. Acceptance of Terms",
                        content: "By creating an account and using PennyPals, you agree to these Terms of Service. If you do not agree to these terms, please do not use our application."
                    )

                    termsCard(
                        title: "2. Privacy and Data",
                        content: "We collect your basic profile information and saving habits to improve your experience with your virtual pet. We do not sell your personal data to third parties. For more details, please review our Privacy Policy."
                    )

                    termsCard(
                        title: "3. Virtual Items and Coins",
                        content: "Coins earned in PennyPals are entirely virtual and have no real-world monetary value. They can only be used to purchase in-app virtual items like accessories and backgrounds for your pet."
                    )
                }
                .padding(.horizontal)

                Spacer(minLength: 40)
            }
            .padding(.top, 24)
        }
        .background(Color.pennyBackground.ignoresSafeArea())
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Komponen Reusable untuk Terms Card
    private func termsCard(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.pennyText)
            
            Text(content)
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
        TermsOfServiceView()
    }
}
