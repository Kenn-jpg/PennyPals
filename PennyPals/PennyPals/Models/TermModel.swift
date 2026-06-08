//
//  TermModel.swift
//  PennyPals
//

import Foundation

// Data Model untuk Terms of Service
struct TermModel: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let content: String
}
