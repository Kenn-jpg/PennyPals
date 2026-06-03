//
//  UserModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseFirestore
import Foundation

// CUKUP TAMBAHKAN Equatable di baris ini
struct UserModel: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var coins: Int
    var streak: Int
    var lastLoginDate: Date
    var createdAt: Date
    var totalSavings: Int

    // Status penalti
    var isSafeFromPenalty: Bool
    var nextPenaltyCheck: Date

    // TAMBAHAN BARU: Status pengecekan onboarding
    var isOnboarded: Bool?

    // Track tanggal terakhir nabung (untuk streak harian)
    var lastSavingsDate: Date?
}
