//
//  TermsOfServiceViewModel.swift
//  PennyPals
//

import Foundation

class TermsOfServiceViewModel: ObservableObject {
    @Published var termsList: [TermModel] = []
    
    init() {
        loadTerms()
    }
    
    private func loadTerms() {
        self.termsList = [
            TermModel(
                icon: "checkmark.seal.fill",
                title: "Acceptance of Terms",
                content: "By creating an account and using PennyPals, you agree to these Terms of Service. If you do not agree to these terms, please do not use our application."
            ),
            TermModel(
                icon: "lock.shield.fill",
                title: "Privacy and Data",
                content: "We collect your basic profile information and saving habits to improve your experience with your virtual pet. We do not sell your personal data to third parties. For more details, please review our Privacy Policy."
            ),
            TermModel(
                icon: "bitcoinsign.circle.fill", // Ikon yang merepresentasikan koin/virtual items
                title: "Virtual Items and Coins",
                content: "Coins earned in PennyPals are entirely virtual and have no real-world monetary value. They can only be used to purchase in-app virtual items like accessories and backgrounds for your pet."
            ),
            TermModel(
                icon: "person.crop.circle.badge.checkmark",
                title: "User Conduct",
                content: "You agree to use PennyPals for its intended purpose of tracking savings habits. Any attempt to manipulate the system or exploit bugs may result in account restriction."
            ),
            TermModel(
                icon: "arrow.triangle.2.circlepath",
                title: "Changes to Terms",
                content: "We reserve the right to modify these terms at any time. We will always notify you of any significant changes directly within the PennyPals app."
            )
        ]
    }
}
