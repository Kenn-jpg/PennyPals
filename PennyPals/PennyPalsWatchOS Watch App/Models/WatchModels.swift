//
//  WatchModels.swift
//  PennyPalsWatchOS Watch App
//

import Foundation

struct WatchUserModel {
    var username: String = "—"
    var email: String = "—"
    var coins: Int = 0
    var streak: Int = 0
    var totalSavings: Int = 0
    var isSafeFromPenalty: Bool = true
    var nextPenaltyCheck: Date = Date()
}

struct WatchPetModel {
    var name: String = "Pal"
    var level: Int = 0
    var xp: Int = 0
    var maxXP: Int = 200
    var mood: String = "hungry"
    var type: String = "rose"
}

struct WatchThemeModel {
    var ownedBackgrounds: [[String: String]] = []
    var selectedBackgroundId: String = ""
}
