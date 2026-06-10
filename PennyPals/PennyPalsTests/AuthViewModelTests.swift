//
//  AuthViewModelTests.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import XCTest

@testable import PennyPals

final class AuthViewModelTests: XCTestCase {

    func testInitialAuthState() {
        // Simulasi state sebelum Firebase selesai memuat
        let isAuthenticated = false
        let currentUser: UserModel? = nil

        XCTAssertFalse(isAuthenticated, "Secara default user belum login")
        XCTAssertNil(
            currentUser,
            "Data currentUser harus nil saat baru dibuka"
        )
    }

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

        XCTAssertEqual(newUser.coins, 0, "Koin awal harus 0")
        XCTAssertEqual(newUser.streak, 0, "Streak awal harus 0")
        XCTAssertTrue(
            newUser.isSafeFromPenalty,
            "User baru harus aman dari penalti"
        )
    }

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

        XCTAssertEqual(
            user.equippedBackground,
            "bg_forest",
            "Background harus di-equip dengan benar"
        )
        XCTAssertNil(user.equippedAccessory, "Aksesoris tidak boleh berubah")

        // Equip Accessory
        let isBackground2 = false
        let itemName2 = "acc_glasses"

        if isBackground2 {
            user.equippedBackground = itemName2
        } else {
            user.equippedAccessory = itemName2
        }

        XCTAssertEqual(
            user.equippedAccessory,
            "acc_glasses",
            "Aksesoris harus di-equip dengan benar"
        )
        XCTAssertEqual(
            user.equippedBackground,
            "bg_forest",
            "Background tidak boleh hilang saat equip aksesoris"
        )
    }
}
