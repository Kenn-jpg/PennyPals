//
//  TermsOfServiceView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 08/06/26.
//

import SwiftUI

struct TermsOfServiceView: View {
    @StateObject private var viewModel = TermsOfServiceViewModel()
    
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
                    ForEach(Array(viewModel.termsList.enumerated()), id: \.element.id) { index, item in
                        TermRowView(item: item)
                        
                        // Garis pemisah antar poin, kecuali untuk elemen terakhir
                        if index < viewModel.termsList.count - 1 {
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
    let item: TermModel
    
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
