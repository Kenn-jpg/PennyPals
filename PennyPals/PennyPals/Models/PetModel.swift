//
//  PetModel.swift
//  PennyPals
//
//  Created by student on 28/05/26.
//


import Foundation
import FirebaseFirestore

struct PetModel: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var name: String
    var type: String       // contoh: "rose", "mint", "sky"
    var xp: Int            // Experience Points
    var level: Int
    var mood: String       // "hungry", "happy", "sad"
    
    // Logika perhitungan max XP per level (bisa disesuaikan)
    var maxXP: Int {
        return level * 1000
    }
}