//
//  TermsOfServiceView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 08/06/26.
//

import SwiftUI

// 1. Data Model untuk Terms agar rapi dan mudah diatur
struct TermItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let content: String
}

struct TermsOfServiceView: View {
    // Daftar poin Terms of Service (Sudah ditambahkan poin baru agar lebih padat)
    let termsList = [
        TermItem(
            icon: "checkmark.seal.fill",
            title: "Acceptance of Terms",
            content: "By creating an account and using PennyPals, you agree to these Terms of Service. If you do not agree to these terms, please do not use our application."
        ),
        TermItem(
            icon: "lock.shield.fill",
            title: "Privacy and Data",
            content: "We collect your basic profile information and saving habits to improve your experience with your virtual pet. We do not sell your personal data to third parties. For more details, please review our Privacy Policy."
        ),
        TermItem(
            icon: "bitcoinsign.circle.fill", // Ikon yang merepresentasikan koin/virtual items
            title: "Virtual Items and Coins",
            content: "Coins earned in PennyPals are entirely virtual and have no real-world monetary value. They can only be used to purchase in-app virtual items like accessories and backgrounds for your pet."
        ),
        TermItem(
            icon: "person.crop.circle.badge.checkmark",
            title: "User Conduct",
            content: "You agree to use PennyPals for its intended purpose of tracking savings habits. Any attempt to manipulate the system or exploit bugs may result in account restriction."
        ),
        TermItem(
            icon: "arrow.triangle.2.circlepath",
            title: "Changes to Terms",
            content: "We reserve the right to modify these terms at any time. We will always notify you of any significant changes directly within the PennyPals app."
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Terms of Service")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.pennyText)
                    
                    Text("Last updated: June 2026")
                        .font(.subheadline)
                        .foregroundColor(.pennySecondaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // MARK: - Terms Content Card (Gaya List yang Elegan)
                VStack(spacing: 0) {
                    ForEach(Array(termsList.enumerated()), id: \.element.id) { index, item in
                        TermRowView(item: item)
                        
                        // Garis pemisah antar poin, kecuali untuk elemen terakhir
                        if index < termsList.count - 1 {
                            Divider()
                                .padding(.leading, 56) // Menyesuaikan dengan letak teks
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
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Component Row View untuk Setiap Poin ToS
struct TermRowView: View {
    let item: TermItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Ikon aksen untuk setiap poin agar tidak kaku
            ZStack {
                Circle()
                    .fill(Color.pennyPurple.opacity(0.12))
                    .frame(width: 32, height: 32)
                
                Image(systemName: item.icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.pennyPurple)
            }
            .padding(.top, 2) // Sedikit penyesuaian agar ikon sejajar dengan teks judul
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.pennyText)
                
                Text(item.content)
                    .font(.footnote)
                    .foregroundColor(.pennySecondaryText)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
    }
}

#Preview {
    NavigationStack {
        TermsOfServiceView()
    }
}
