//
//  TermModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import Foundation

/// Model yang merepresentasikan data Terms of Service atau Syarat & Ketentuan.
struct TermModel: Identifiable {
    let id = UUID()

    /// Nama ikon SF Symbols atau Assets yang mewakili poin ini.
    let icon: String

    /// Judul dari syarat/ketentuan.
    let title: String

    /// Penjelasan detail mengenai syarat/ketentuan tersebut.
    let content: String
}
