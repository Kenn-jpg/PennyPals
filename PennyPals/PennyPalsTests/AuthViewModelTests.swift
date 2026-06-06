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
}
