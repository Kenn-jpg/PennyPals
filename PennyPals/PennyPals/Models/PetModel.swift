//
//  PetModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseFirestore
import Foundation

struct PetModel: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var name: String
    var type: String  // contoh: "rose", "mint", "sky"
    var xp: Int  // Experience Points
    var level: Int
    var mood: String  // "hungry", "happy", "sad"

    // Logika perhitungan max XP per level:
    // Lvl 0 -> 200, Lvl 1 -> 400, Lvl 2 -> 600, dst. (Unlimited)
    var maxXP: Int {
        return (level + 1) * 200
    }
}
