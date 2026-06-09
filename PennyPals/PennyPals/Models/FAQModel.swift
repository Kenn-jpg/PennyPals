//
//  FAQModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import Foundation

/// Model yang merepresentasikan data Frequently Asked Questions (FAQ).
struct FAQModel: Identifiable {
    let id = UUID()

    /// Pertanyaan yang sering diajukan.
    let question: String

    /// Jawaban dari pertanyaan tersebut.
    let answer: String
}
