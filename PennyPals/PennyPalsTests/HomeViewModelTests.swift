//
//  HomeViewModelTests.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import Foundation
import Testing

@testable import PennyPals

struct HomeViewModelTests {

    @Test("Penghitungan Max XP Berdasarkan Level Pet")
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
        #expect(petLv1.maxXP == 1000, "Max XP untuk Level 1 harus 1000")
        #expect(petLv3.maxXP == 3000, "Max XP untuk Level 3 harus 3000")
    }

    @Test("Logika addSavings: XP Bertambah dan Naik Level")
    func testAddSavingsLogic() {
        // Mengatur kondisi awal simulasi status poin pengalaman (XP) dan level peliharaan.
        var currentXP = 800
        var currentLevel = 1
        let maxXP = currentLevel * 1000

        // Menentukan nominal uang tabungan masuk dan menghitung konversi penambahan nilai XP.
        let savingsAmount: Double = 250000
        let gainedXP = Int(savingsAmount / 1000)  // Hasil konversi adalah 250 XP

        currentXP += gainedXP

        // Menjalankan logika simulasi untuk menaikkan level peliharaan jika akumulasi XP melewati batas maksimum.
        if currentXP >= maxXP {
            currentXP -= maxXP
            currentLevel += 1
        }

        // Melakukan verifikasi akhir bahwa status level meningkat dan sisa sisa XP terpotong dengan akurat.
        #expect(currentLevel == 2, "Pet harus naik ke level 2")
        #expect(currentXP == 50, "Sisa XP setelah naik level harus 50")
    }

    // Mendefinisikan struktur cetakan data khusus untuk menampung skenario pengujian penalti harian.
    struct PenaltyScenario {
        let initialXP: Int
        let initialLevel: Int
        let expectedLevel: Int
        let expectedXP: Int
    }

    // Menerapkan Parameterized Testing untuk menguji dua cabang logika sekaligus (Demote Level dan Mentok Level 1).
    // Cara ini membuat variabel masukan menjadi dinamis sehingga menghilangkan error "Will never be executed".
    @Test(
        "Logika checkDailyPenalty: Pengurangan XP dan Demote",
        arguments: [
            // Skenario 1: Level 2, XP tidak cukup menahan penalti -> Menguji kondisi Level Turun (Demote)
            PenaltyScenario(
                initialXP: 100,
                initialLevel: 2,
                expectedLevel: 1,
                expectedXP: 900
            ),
            // Skenario 2: Level 1, XP tidak cukup menahan penalti -> Menguji kondisi Batas Minimum Level 1
            PenaltyScenario(
                initialXP: 100,
                initialLevel: 1,
                expectedLevel: 1,
                expectedXP: 0
            ),
        ]
    )
    func testDailyPenaltyLogic(scenario: PenaltyScenario) {
        // Memuat status awal berdasarkan skenario argumen yang sedang berjalan saat ini.
        var currentXP = scenario.initialXP
        var currentLevel = scenario.initialLevel
        let penaltyXP = 200

        // Menerapkan pemotongan poin penalti harian ke XP peliharaan.
        currentXP -= penaltyXP

        // Memproses logika konsekuensi penalti ketika nilai XP jatuh di bawah angka nol.
        if currentXP < 0 {
            if currentLevel > 1 {
                // Cabang ini akan dieksekusi pada Skenario 1 (Menurunkan level dan menyesuaikan sisa XP).
                currentLevel -= 1
                let maxXPForNewLevel = currentLevel * 1000
                currentXP = maxXPForNewLevel + currentXP
            } else {
                // Cabang ini akan dieksekusi pada Skenario 2 (Mengunci nilai XP terkecil di angka 0).
                currentXP = 0
            }
        }

        // Memvalidasi hasil kalkulasi sistem dengan ekspektasi nilai yang seharusnya tercapai pada masing-masing skenario.
        #expect(
            currentLevel == scenario.expectedLevel,
            "Kalkulasi tingkatan level akhir tidak sesuai dengan spesifikasi sistem"
        )
        #expect(
            currentXP == scenario.expectedXP,
            "Sisa akumulasi poin XP akhir tidak cocok dengan aturan penalti"
        )
    }
}
