//
//  HelpCenterView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 08/06/26.
//

import SwiftUI

struct HelpCenterView: View {
    @StateObject private var viewModel = HelpCenterViewModel()
    
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
                    ForEach(Array(viewModel.faqList.enumerated()), id: \.element.id) { index, item in
                        FAQRowView(item: item)
                        
                        // Berikan divider di antara item, tapi jangan di item terakhir
                        if index < viewModel.faqList.count - 1 {
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
    let item: FAQModel
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
