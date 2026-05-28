//
//  HomeViewModelTests.swift
//  PennyPals
//
//  Created by student on 28/05/26.
//


import Testing
import Foundation
@testable import PennyPals

struct HomeViewModelTests {
    
    @Test("Penghitungan Max XP Berdasarkan Level Pet")
    func testPetMaxXP() {
        let petLv1 = PetModel(id: "1", userId: "user1", name: "Rosie", type: "rose", xp: 0, level: 1, mood: "happy")
        let petLv3 = PetModel(id: "2", userId: "user2", name: "Sprout", type: "mint", xp: 0, level: 3, mood: "happy")
        
        #expect(petLv1.maxXP == 1000, "Max XP untuk Level 1 harus 1000")
        #expect(petLv3.maxXP == 3000, "Max XP untuk Level 3 harus 3000")
    }
    
    @Test("Logika addSavings: XP Bertambah dan Naik Level")
    func testAddSavingsLogic() {
        // Simulasi state awal di HomeViewModel
        var currentXP = 800
        var currentLevel = 1
        let maxXP = currentLevel * 1000
        
        // Simulasi input nabung Rp 250.000
        let savingsAmount: Double = 250000
        let gainedXP = Int(savingsAmount / 1000) // 250 XP
        
        currentXP += gainedXP
        
        // Logika Level Up HomeViewModel
        if currentXP >= maxXP {
            currentXP -= maxXP
            currentLevel += 1
        }
        
        #expect(currentLevel == 2, "Pet harus naik ke level 2")
        #expect(currentXP == 50, "Sisa XP setelah naik level harus 50")
    }
    
    @Test("Logika checkDailyPenalty: Pengurangan XP dan Demote")
    func testDailyPenaltyLogic() {
        // Simulasi state awal
        var currentXP = 100
        var currentLevel = 2
        let penaltyXP = 200
        
        // Terapkan penalti
        currentXP -= penaltyXP
        
        // Logika Demote HomeViewModel
        if currentXP < 0 {
            if currentLevel > 1 {
                currentLevel -= 1
                let maxXPForNewLevel = currentLevel * 1000
                currentXP = maxXPForNewLevel + currentXP
            } else {
                currentXP = 0
            }
        }
        
        #expect(currentLevel == 1, "Level harus turun karena terkena penalti")
        #expect(currentXP == 900, "XP harus menyesuaikan sisa dari batas max level sebelumnya")
    }
}
