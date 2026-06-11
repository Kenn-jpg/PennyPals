//
//  PennyPalsWidgetViewModel.swift
//  PennyPalsWidget
//

import Foundation

class PennyPalsWidgetViewModel {
    
    /// Mengambil data pet dari App Group (dibagikan dari aplikasi utama)
    func fetchPetData() -> WidgetPetModel {
        let sharedDefaults = UserDefaults(suiteName: "group.com.MAD.PennyPals")
        let name = sharedDefaults?.string(forKey: "widgetPetName") ?? "Your Pet"
        let level = sharedDefaults?.integer(forKey: "widgetPetLevel") ?? 1
        let xp = sharedDefaults?.integer(forKey: "widgetPetXP") ?? 0
        let maxXP = sharedDefaults?.integer(forKey: "widgetPetMaxXP") ?? 200
        let mood = sharedDefaults?.string(forKey: "widgetPetMood") ?? "hungry"
        
        return WidgetPetModel(name: name, level: level, xp: xp, maxXP: maxXP, mood: mood)
    }
    
    /// Konversi string mood ke emoji yang sesuai
    func moodEmoji(for mood: String) -> String {
        switch mood {
        case "happy": return "😊"
        case "sad": return "😢"
        case "hungry": return "🥺"
        case "angry": return "😡"
        case "surprised": return "😲"
        case "cry": return "😭"
        case "sleepy": return "😴"
        case "dizzy": return "😵"
        case "wink": return "😉"
        default: return "🐾"
        }
    }
    
    /// Menghitung persentase progress XP (0.0 - 1.0)
    func xpProgressRatio(xp: Int, maxXP: Int) -> Double {
        let safeMax = max(1, maxXP)
        let progress = Double(xp) / Double(safeMax)
        return max(0, min(progress, 1.0))
    }
}
