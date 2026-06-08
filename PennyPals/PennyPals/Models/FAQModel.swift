//
//  FAQModel.swift
//  PennyPals
//

import Foundation

// Data Model untuk FAQ
struct FAQModel: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}
