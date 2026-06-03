//
//  PenaltyStatus.swift
//  PennyPals
//
//  Created by Kelompok 8 on 03/06/26.
//

import Foundation

/// Status indikator keselamatan progres gamifikasi berdasarkan tingkat kepatuhan pengguna menabung.
enum PenaltyStatus: Equatable {
    /// Pengguna patuh menabung dan progresnya aman.
    case safe

    /// Peringatan awal bahwa sisa waktu menuju batas penalti sudah kritis (< 24 jam).
    case warning

    /// Pengguna melanggar batas waktu dan berisiko terkena atau telah menerima penalti (pengurangan XP/Level).
    case danger
}
