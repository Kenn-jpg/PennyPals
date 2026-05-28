//
//  UserModel.swift
//  PennyPals
//
//  Created by Keane Juan Suryanto on 28/05/26.
//

import Foundation
import FirebaseFirestore

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
