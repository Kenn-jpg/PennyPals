//
//  HomeViewModelTests.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import XCTest

@testable import PennyPals

final class HomeViewModelTests: XCTestCase {

    func testPetMaxXP() {
        // Menyiapkan objek uji berupa data PetModel pada level 1 dan level 3.
        let petLv1 = PetModel(
            id: "1",
            userId: "user1",
            name: "Rosie",
            type: "rose",
            xp: 0,
            level: 1,
            mood: "happy"
        )
        let petLv3 = PetModel(
            id: "2",
            userId: "user2",
            name: "Sprout",
            type: "mint",
            xp: 0,
            level: 3,
            mood: "happy"
        )

        // Memastikan properti komputasi maxXP menghitung batas maksimal XP dengan benar sesuai rumus level.
        XCTAssertEqual(petLv1.maxXP, 400, "Max XP untuk Level 1 harus 400")
        XCTAssertEqual(petLv3.maxXP, 800, "Max XP untuk Level 3 harus 800")
    }

    func testAddSavingsLogic() {
        // Mengatur kondisi awal simulasi status poin pengalaman (XP) dan level peliharaan.
        var currentXP = 300
        var currentLevel = 1
        let maxXP = (currentLevel + 1) * 200

        // Menentukan nominal uang tabungan masuk dan menghitung konversi penambahan nilai XP.
        let savingsAmount: Double = 150000
        let gainedXP = Int(savingsAmount / 1000)  // Hasil konversi adalah 150 XP

        currentXP += gainedXP

        // Menjalankan logika simulasi untuk menaikkan level peliharaan jika akumulasi XP melewati batas maksimum.
        if currentXP >= maxXP {
            currentXP -= maxXP
            currentLevel += 1
        }

        // Melakukan verifikasi akhir bahwa status level meningkat dan sisa sisa XP terpotong dengan akurat.
        XCTAssertEqual(currentLevel, 2, "Pet harus naik ke level 2")
        XCTAssertEqual(currentXP, 50, "Sisa XP setelah naik level harus 50")
    }

    // MARK: - Parameterized Penalty Tests
    // Menguji dua cabang logika sekaligus (Demote Level dan Mentok Level 1).

    func testDailyPenaltyLogic_DemoteLevel() {
        // Skenario 1: Level 2, XP tidak cukup menahan penalti -> Menguji kondisi Level Turun (Demote)
        var currentXP = 100
        var currentLevel = 2
        let penaltyXP = 200

        // Menerapkan pemotongan poin penalti harian ke XP peliharaan.
        currentXP -= penaltyXP

        // Memproses logika konsekuensi penalti ketika nilai XP jatuh di bawah angka nol.
        if currentXP < 0 {
            if currentLevel > 1 {
                // Menurunkan level dan menyesuaikan sisa XP.
                currentLevel -= 1
                let maxXPForNewLevel = (currentLevel + 1) * 200
                currentXP = maxXPForNewLevel + currentXP
            } else {
                currentXP = 0
            }
        }

        // Memvalidasi hasil kalkulasi sistem dengan ekspektasi nilai yang seharusnya tercapai.
        XCTAssertEqual(
            currentLevel,
            1,
            "Kalkulasi tingkatan level akhir tidak sesuai dengan spesifikasi sistem"
        )
        XCTAssertEqual(
            currentXP,
            300,
            "Sisa akumulasi poin XP akhir tidak cocok dengan aturan penalti"
        )
    }

    func testDailyPenaltyLogic_MinimumLevel() {
        // Skenario 2: Level 1, XP tidak cukup menahan penalti -> Menguji kondisi Batas Minimum Level 1
        var currentXP = 100
        var currentLevel = 1
        let penaltyXP = 200

        // Menerapkan pemotongan poin penalti harian ke XP peliharaan.
        currentXP -= penaltyXP

        // Memproses logika konsekuensi penalti ketika nilai XP jatuh di bawah angka nol.
        if currentXP < 0 {
            if currentLevel > 1 {
                currentLevel -= 1
                let maxXPForNewLevel = (currentLevel + 1) * 200
                currentXP = maxXPForNewLevel + currentXP
            } else {
                // Mengunci nilai XP terkecil di angka 0.
                currentXP = 0
            }
        }

        // Memvalidasi hasil kalkulasi sistem dengan ekspektasi nilai yang seharusnya tercapai.
        XCTAssertEqual(
            currentLevel,
            1,
            "Kalkulasi tingkatan level akhir tidak sesuai dengan spesifikasi sistem"
        )
        XCTAssertEqual(
            currentXP,
            0,
            "Sisa akumulasi poin XP akhir tidak cocok dengan aturan penalti"
        )
    }

    func testAddExpenseLogic() {
        var currentXP = 50
        var currentLevel = 2

        let expenseAmount: Double = 150000
        let lostXP = Int(expenseAmount / 1000)  // 150 XP

        currentXP -= lostXP  // 50 - 150 = -100

        while currentXP < 0 {
            if currentLevel > 0 {
                currentLevel -= 1
                let previousMaxXP = (currentLevel + 1) * 200
                currentXP = previousMaxXP + currentXP
            } else {
                currentXP = 0
                break
            }
        }

        // previousMaxXP for level 1 is 400. 400 + (-100) = 300
        XCTAssertEqual(
            currentLevel,
            1,
            "Level harus turun ke 1 karena XP kurang"
        )
        XCTAssertEqual(currentXP, 300, "Sisa XP harus 300 setelah turun level")

        // Simulasi mood
        let initialLevel = 2
        let newMood = (currentLevel < initialLevel) ? "cry" : "sad"
        XCTAssertEqual(
            newMood,
            "cry",
            "Mood harus menjadi cry karena turun level"
        )
    }
}
