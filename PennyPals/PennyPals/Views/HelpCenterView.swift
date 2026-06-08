//
//  HelpCenterView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 08/06/26.
//

import SwiftUI

// 1. Data Model untuk FAQ
struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct HelpCenterView: View {
    // Mock Data FAQ yang sudah diperbanyak agar halaman tidak kosong
    let faqList = [
        FAQItem(
            question: "How do I hatch my pet?",
            answer: "Simply set a savings goal and start saving! Once you make your first deposit, your egg will hatch into a surprise PennyPal."
        ),
        FAQItem(
            question: "What happens if I miss a day?",
            answer: "If you miss a day, your pet might become hungry or sad. Continuing to miss days could result in losing some XP, so keep your streak alive!"
        ),
        FAQItem(
            question: "How do I buy accessories?",
            answer: "Every time you save, you earn coins! Use these coins in the Shop tab to buy cute hats, glasses, and backgrounds for your pet."
        ),
        FAQItem(
            question: "How do I level up my PennyPal?",
            answer: "Your pet gains XP every time you reach a savings milestone or maintain a daily streak. Keep logging your savings consistently to watch them grow and level up!"
        ),
        FAQItem(
            question: "Can I change my savings goal?",
            answer: "Yes, absolutely! You can edit your active savings goal at any time by tapping on the wishlist card on the Home screen and selecting 'Set New Goal'."
        ),
        FAQItem(
            question: "How do I edit my profile?",
            answer: "Head over to the Account tab and tap 'Edit Profile'. From there, you can update your username, email, and other personal preferences."
        ),
        FAQItem(
            question: "Is my money actually stored in the app?",
            answer: "No, PennyPals is a savings tracker. We don't connect to your bank account or store real money. We simply help you build the habit of saving by tracking your progress in a fun way!"
        ),
        FAQItem(
            question: "What should I do if I find a bug?",
            answer: "Oh no! If something isn't working right, please reach out to us by sending an email to support@pennypals.app with a screenshot and detail of the issue."
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("How can we help you?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.pennyText)
                    
                    Text("Find answers to frequently asked questions about PennyPals.")
                        .font(.subheadline)
                        .foregroundColor(.pennySecondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // MARK: - Grouped FAQ Section
                VStack(spacing: 0) {
                    ForEach(Array(faqList.enumerated()), id: \.element.id) { index, item in
                        FAQRowView(item: item)
                        
                        // Berikan divider di antara item, tapi jangan di item terakhir
                        if index < faqList.count - 1 {
                            Divider()
                                .padding(.leading, 56) // Geser sedikit agar sejajar dengan teks
                                .opacity(0.6)
                        }
                    }
                }
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: Color.black.opacity(0.03), radius: 12, x: 0, y: 6)
                .padding(.horizontal, 20)
                
                Spacer(minLength: 40)
            }
        }
        .background(Color.pennyBackground.ignoresSafeArea())
        .navigationTitle("Help Center")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Component FAQ Row View
struct FAQRowView: View {
    let item: FAQItem
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 16) {
                    // Penanda ikon kecil interaktif
                    ZStack {
                        Circle()
                            .fill(isExpanded ? Color.pennyPurple.opacity(0.1) : Color.gray.opacity(0.05))
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "questionmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(isExpanded ? .pennyPurple : .pennySecondaryText)
                    }
                    
                    Text(item.question)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.pennyText)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.pennyPurple.opacity(0.7))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.vertical, 20)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Text(item.answer)
                    .font(.footnote)
                    .foregroundColor(.pennySecondaryText)
                    .lineSpacing(5)
                    .padding(.leading, 40) // Biar menjorok ke dalam setelah ikon tanda tanya
                    .padding(.bottom, 20)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    NavigationStack {
        HelpCenterView()
    }
}
