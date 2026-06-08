//
//  HelpCenterViewModel.swift
//  PennyPals
//

import Foundation

class HelpCenterViewModel: ObservableObject {
    @Published var faqList: [FAQModel] = []
    
    init() {
        loadFAQs()
    }
    
    private func loadFAQs() {
        // Mock Data FAQ
        self.faqList = [
            FAQModel(
                question: "How do I hatch my pet?",
                answer: "Simply set a savings goal and start saving! Once you make your first deposit, your egg will hatch into a surprise PennyPal."
            ),
            FAQModel(
                question: "What happens if I miss a day?",
                answer: "If you miss a day, your pet might become hungry or sad. Continuing to miss days could result in losing some XP, so keep your streak alive!"
            ),
            FAQModel(
                question: "How do I buy accessories?",
                answer: "Every time you save, you earn coins! Use these coins in the Shop tab to buy cute hats, glasses, and backgrounds for your pet."
            ),
            FAQModel(
                question: "How do I level up my PennyPal?",
                answer: "Your pet gains XP every time you reach a savings milestone or maintain a daily streak. Keep logging your savings consistently to watch them grow and level up!"
            ),
            FAQModel(
                question: "Can I change my savings goal?",
                answer: "Yes, absolutely! You can edit your active savings goal at any time by tapping on the wishlist card on the Home screen and selecting 'Set New Goal'."
            ),
            FAQModel(
                question: "How do I edit my profile?",
                answer: "Head over to the Account tab and tap 'Edit Profile'. From there, you can update your username, email, and other personal preferences."
            ),
            FAQModel(
                question: "Is my money actually stored in the app?",
                answer: "No, PennyPals is a savings tracker. We don't connect to your bank account or store real money. We simply help you build the habit of saving by tracking your progress in a fun way!"
            ),
            FAQModel(
                question: "What should I do if I find a bug?",
                answer: "Oh no! If something isn't working right, please reach out to us by sending an email to support@pennypals.app with a screenshot and detail of the issue."
            )
        ]
    }
}
