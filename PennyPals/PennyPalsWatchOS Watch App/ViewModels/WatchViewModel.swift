//
//  WatchViewModel.swift
//  PennyPalsWatchOS Watch App
//

import Foundation
import Combine
import SwiftUI

class WatchViewModel: ObservableObject, IOSConnectivityDelegate {
    
    // MARK: - Published Models
    @Published var user = WatchUserModel()
    @Published var pet = WatchPetModel()
    @Published var theme = WatchThemeModel()
    @Published var isConnected: Bool = false
    
    // MARK: - Service
    private let connectivityService: IOSConnectivityService
    
    init(connectivityService: IOSConnectivityService = .shared) {
        self.connectivityService = connectivityService
        self.connectivityService.delegate = self
    }
    
    // MARK: - Actions
    func requestRefresh() {
        connectivityService.requestRefresh()
    }
    
    func equipBackground(id: String) {
        // Speculatively update local UI
        self.theme.selectedBackgroundId = id
        connectivityService.equipBackground(id: id)
    }
    
    // MARK: - IOSConnectivityDelegate Methods
    func didReceiveUserUpdate(data: [String : Any]) {
        if let username = data["username"] as? String { user.username = username }
        if let email = data["email"] as? String { user.email = email }
        if let coins = data["coins"] as? Int { user.coins = coins }
        if let streak = data["streak"] as? Int { user.streak = streak }
        if let totalSavings = data["totalSavings"] as? Int { user.totalSavings = totalSavings }
        if let isSafe = data["isSafeFromPenalty"] as? Bool { user.isSafeFromPenalty = isSafe }
        if let nextCheck = data["nextPenaltyCheck"] as? TimeInterval {
            user.nextPenaltyCheck = Date(timeIntervalSince1970: nextCheck)
        }
    }
    
    func didReceivePetUpdate(data: [String : Any]) {
        if let name = data["petName"] as? String { pet.name = name }
        if let level = data["petLevel"] as? Int { pet.level = level }
        if let xp = data["petXP"] as? Int { pet.xp = xp }
        if let maxXP = data["petMaxXP"] as? Int { pet.maxXP = maxXP }
        if let mood = data["petMood"] as? String { pet.mood = mood }
        if let type = data["petType"] as? String { pet.type = type }
    }
    
    func didReceiveInventoryUpdate(data: [String : Any]) {
        if let bgs = data["ownedBackgrounds"] as? [[String: String]] { theme.ownedBackgrounds = bgs }
        if let selectedId = data["selectedBackgroundId"] as? String { theme.selectedBackgroundId = selectedId }
    }
    
    func didReceiveLogout() {
        self.user = WatchUserModel()
        self.pet = WatchPetModel()
        self.theme = WatchThemeModel()
    }
    
    func connectionStateChanged(isConnected: Bool) {
        self.isConnected = isConnected
    }
    
    // MARK: - Computed Properties for Views (Moved from Views)
    
    var xpProgressRatio: CGFloat {
        guard pet.maxXP > 0 else { return 0 }
        return CGFloat(pet.xp) / CGFloat(pet.maxXP)
    }
    
    var moodEmoji: String {
        switch pet.mood.lowercased() {
        case "happy": return "😊"
        case "sad": return "😢"
        case "hungry": return "🥺"
        case "angry": return "😡"
        case "cry": return "😭"
        case "dizzy": return "😵"
        case "sleepy": return "😴"
        case "surprised": return "😲"
        case "wink": return "😉"
        default: return "🐾"
        }
    }
    
    var moodSuffix: String {
        switch pet.mood.lowercased() {
        case "happy": return "Laugh"
        case "sad": return "Sad"
        case "hungry": return "TongueOut"
        case "angry": return "Angry"
        case "cry": return "Cry"
        case "dizzy": return "Dizzy"
        case "sleepy": return "Sleepy"
        case "surprised": return "Surprised"
        case "wink": return "WinkTongueOut"
        default: return "Laugh"
        }
    }
    
    var avatarInitials: String {
        String(user.username.prefix(2)).uppercased()
    }
    
    var penaltyIcon: String {
        if !user.isSafeFromPenalty {
            return "xmark.shield.fill"
        }
        let hoursRemaining = Calendar.current.dateComponents([.hour], from: Date(), to: user.nextPenaltyCheck).hour ?? 0
        if hoursRemaining <= 24 {
            return "exclamationmark.triangle.fill"
        }
        return "checkmark.shield.fill"
    }

    var penaltyColor: Color {
        if !user.isSafeFromPenalty { return .red }
        let hoursRemaining = Calendar.current.dateComponents([.hour], from: Date(), to: user.nextPenaltyCheck).hour ?? 0
        if hoursRemaining <= 24 { return .orange }
        return .green
    }

    var penaltyText: String {
        if !user.isSafeFromPenalty { return "Penalty Active" }
        let hoursRemaining = Calendar.current.dateComponents([.hour], from: Date(), to: user.nextPenaltyCheck).hour ?? 0
        if hoursRemaining <= 24 { return "Save soon!" }
        return "Safe ✓"
    }
    
    var backgroundGradient: LinearGradient {
        let currentBg = theme.ownedBackgrounds.first(where: { $0["id"] == theme.selectedBackgroundId })
        let colorHex = currentBg?["colorHex"] ?? "#FFF1F6"
        let spotsHex = currentBg?["spotsHex"] ?? "#E8F4FF"
        
        return LinearGradient(
            colors: [Color(hex: colorHex), Color(hex: spotsHex)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
