//
//  TermsOfServiceView.swift
//  PennyPals
//

import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Terms of Service")
                    .font(.title2.bold())
                    .foregroundColor(.pennyText)

                Text("Last updated: June 2026")
                    .font(.footnote)
                    .foregroundColor(.gray)

                VStack(alignment: .leading, spacing: 8) {
                    Text("1. Acceptance of Terms")
                        .font(.headline)
                        .foregroundColor(.pennyText)
                    Text("By creating an account and using PennyPals, you agree to these Terms of Service. If you do not agree to these terms, please do not use our application.")
                        .font(.body)
                        .foregroundColor(.pennySecondaryText)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("2. Privacy and Data")
                        .font(.headline)
                        .foregroundColor(.pennyText)
                    Text("We collect your basic profile information and saving habits to improve your experience with your virtual pet. We do not sell your personal data to third parties. For more details, please review our Privacy Policy.")
                        .font(.body)
                        .foregroundColor(.pennySecondaryText)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("3. Virtual Items and Coins")
                        .font(.headline)
                        .foregroundColor(.pennyText)
                    Text("Coins earned in PennyPals are entirely virtual and have no real-world monetary value. They can only be used to purchase in-app virtual items like accessories and backgrounds for your pet.")
                        .font(.body)
                        .foregroundColor(.pennySecondaryText)
                }

                Spacer()
            }
            .padding()
        }
        .background(Color.pennyBackground.ignoresSafeArea())
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TermsOfServiceView()
    }
}
