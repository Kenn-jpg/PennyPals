//
//  UserModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseFirestore
import Foundation

struct UserModel: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var coins: Int
    var streak: Int
    var lastLoginDate: Date
    var createdAt: Date

    // Status penalti
    var isSafeFromPenalty: Bool
    var nextPenaltyCheck: Date
}
