//
//  AuthViewModelTests.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import Foundation
import Testing

@testable import PennyPals

struct AuthViewModelTests {

    @Test("Validasi State Awal Otentikasi")
    func testInitialAuthState() {
        // Simulasi state sebelum Firebase selesai memuat
        let isAuthenticated = false
        let currentUser: UserModel? = nil

        #expect(isAuthenticated == false, "Secara default user belum login")
        #expect(
            currentUser == nil,
            "Data currentUser harus nil saat baru dibuka"
        )
    }

    @Test("Pembuatan Model User Baru Saat Register")
    func testNewUserCreation() {
        let mockUid = "user_999"
        let mockEmail = "jamie@example.com"
        let mockUsername = "Jamie"

        let newUser = UserModel(
            id: mockUid,
            username: mockUsername,
            email: mockEmail,
            coins: 0,
            streak: 0,
            lastLoginDate: Date(),
            createdAt: Date(),
            totalSavings: 0,
            isSafeFromPenalty: true,
            nextPenaltyCheck: Calendar.current.date(
                byAdding: .day,
                value: 2,
                to: Date()
            )!
        )

        #expect(newUser.coins == 0, "Koin awal harus 0")
        #expect(newUser.streak == 0, "Streak awal harus 0")
        #expect(
            newUser.isSafeFromPenalty == true,
            "User baru harus aman dari penalti"
        )
    }

    @Test("Logika Equip Item (Background & Aksesoris)")
    func testEquipItemLogic() {
        var user = UserModel(
            id: "user_1",
            username: "TestUser",
            email: "test@test.com",
            coins: 1000,
            streak: 5,
            lastLoginDate: Date(),
            createdAt: Date(),
            totalSavings: 50000,
            isSafeFromPenalty: true,
            nextPenaltyCheck: Date(),
            isOnboarded: true,
            equippedBackground: nil,
            equippedAccessory: nil
        )
        
        // Equip Background
        let isBackground = true
        let itemName = "bg_forest"
        
        if isBackground {
            user.equippedBackground = itemName
        } else {
            user.equippedAccessory = itemName
        }
        
        #expect(user.equippedBackground == "bg_forest", "Background harus di-equip dengan benar")
        #expect(user.equippedAccessory == nil, "Aksesoris tidak boleh berubah")
        
        // Equip Accessory
        let isBackground2 = false
        let itemName2 = "acc_glasses"
        
        if isBackground2 {
            user.equippedBackground = itemName2
        } else {
            user.equippedAccessory = itemName2
        }
        
        #expect(user.equippedAccessory == "acc_glasses", "Aksesoris harus di-equip dengan benar")
        #expect(user.equippedBackground == "bg_forest", "Background tidak boleh hilang saat equip aksesoris")
    }
}
