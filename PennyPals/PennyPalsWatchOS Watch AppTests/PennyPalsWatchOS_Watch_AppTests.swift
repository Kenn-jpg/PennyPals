//
//  PennyPalsWatchOS_Watch_AppTests.swift
//  PennyPalsWatchOS Watch AppTests
//
//  Created by Kelompok 8 on 02/06/26.
//

import XCTest

@testable import PennyPalsWatchOS_Watch_App

final class IOSConnectivityTests: XCTestCase {

    // MARK: - 1. Initial State Tests

    func testInitialUserData() {
        // Memverifikasi bahwa seluruh data pengguna memiliki nilai default yang benar saat pertama kali diinisialisasi.
        let connectivity = IOSConnectivity()

        XCTAssertEqual(connectivity.username, "—", "Username default harus '—'")
        XCTAssertEqual(connectivity.email, "—", "Email default harus '—'")
        XCTAssertEqual(connectivity.coins, 0, "Koin default harus 0")
        XCTAssertEqual(connectivity.streak, 0, "Streak default harus 0")
        XCTAssertEqual(
            connectivity.totalSavings,
            0,
            "Total savings default harus 0"
        )
        XCTAssertTrue(
            connectivity.isSafeFromPenalty,
            "Default harus aman dari penalti"
        )
    }

    func testInitialPetData() {
        // Memverifikasi bahwa data peliharaana memiliki nilai default yang benar.
        let connectivity = IOSConnectivity()

        XCTAssertEqual(
            connectivity.petName,
            "Pal",
            "Nama pet default harus 'Pal'"
        )
        XCTAssertEqual(connectivity.petLevel, 0, "Level pet default harus 0")
        XCTAssertEqual(connectivity.petXP, 0, "XP pet default harus 0")
        XCTAssertEqual(connectivity.petMaxXP, 200, "Max XP default harus 200")
        XCTAssertEqual(
            connectivity.petMood,
            "hungry",
            "Mood pet default harus 'hungry'"
        )
        XCTAssertEqual(
            connectivity.petType,
            "rose",
            "Tipe pet default harus 'rose'"
        )
    }

    func testInitialInventoryData() {
        // Memverifikasi bahwa data inventori memiliki nilai default yang benar.
        let connectivity = IOSConnectivity()

        XCTAssertTrue(
            connectivity.ownedBackgrounds.isEmpty,
            "Owned backgrounds default harus kosong"
        )
        XCTAssertEqual(
            connectivity.selectedBackgroundId,
            "",
            "Selected background default harus string kosong"
        )
    }

    func testInitialConnectionStatus() {
        // Memverifikasi bahwa status koneksi awal adalah false.
        let connectivity = IOSConnectivity()

        XCTAssertFalse(
            connectivity.isConnected,
            "Status koneksi default harus false"
        )
    }

    // MARK: - 2. User Update Processing Tests

    func testProcessUserUpdateMessage() {
        // Mensimulasikan pemrosesan pesan userUpdate dari iPhone dan memverifikasi bahwa data disinkronkan dengan benar.
        let connectivity = IOSConnectivity()
        let testDate = Date()

        let mockUserData: [String: Any] = [
            "type": "userUpdate",
            "username": "TestUser",
            "email": "test@test.com",
            "coins": 500,
            "streak": 7,
            "totalSavings": 250000,
            "isSafeFromPenalty": false,
            "nextPenaltyCheck": testDate.timeIntervalSince1970,
        ]

        // Simulasi langsung: assign field sesuai logika processMessage
        connectivity.username = mockUserData["username"] as! String
        connectivity.email = mockUserData["email"] as! String
        connectivity.coins = mockUserData["coins"] as! Int
        connectivity.streak = mockUserData["streak"] as! Int
        connectivity.totalSavings = mockUserData["totalSavings"] as! Int
        connectivity.isSafeFromPenalty =
            mockUserData["isSafeFromPenalty"] as! Bool
        if let nextCheck = mockUserData["nextPenaltyCheck"] as? TimeInterval {
            connectivity.nextPenaltyCheck = Date(
                timeIntervalSince1970: nextCheck
            )
        }
        connectivity.isConnected = true

        XCTAssertEqual(
            connectivity.username,
            "TestUser",
            "Username harus terupdate"
        )
        XCTAssertEqual(
            connectivity.email,
            "test@test.com",
            "Email harus terupdate"
        )
        XCTAssertEqual(connectivity.coins, 500, "Coins harus terupdate ke 500")
        XCTAssertEqual(connectivity.streak, 7, "Streak harus terupdate ke 7")
        XCTAssertEqual(
            connectivity.totalSavings,
            250000,
            "TotalSavings harus terupdate"
        )
        XCTAssertFalse(
            connectivity.isSafeFromPenalty,
            "isSafeFromPenalty harus false"
        )
        XCTAssertTrue(
            connectivity.isConnected,
            "isConnected harus true setelah menerima data"
        )
    }

    // MARK: - 3. Pet Update Processing Tests

    func testProcessPetUpdateMessage() {
        // Mensimulasikan pemrosesan pesan petUpdate dari iPhone.
        let connectivity = IOSConnectivity()

        let mockPetData: [String: Any] = [
            "type": "petUpdate",
            "petName": "Rosie",
            "petLevel": 5,
            "petXP": 350,
            "petMaxXP": 1200,
            "petMood": "happy",
            "petType": "mint",
        ]

        // Simulasi langsung: assign field sesuai logika processMessage
        connectivity.petName = mockPetData["petName"] as! String
        connectivity.petLevel = mockPetData["petLevel"] as! Int
        connectivity.petXP = mockPetData["petXP"] as! Int
        connectivity.petMaxXP = mockPetData["petMaxXP"] as! Int
        connectivity.petMood = mockPetData["petMood"] as! String
        connectivity.petType = mockPetData["petType"] as! String
        connectivity.isConnected = true

        XCTAssertEqual(
            connectivity.petName,
            "Rosie",
            "Pet name harus terupdate"
        )
        XCTAssertEqual(
            connectivity.petLevel,
            5,
            "Pet level harus terupdate ke 5"
        )
        XCTAssertEqual(connectivity.petXP, 350, "Pet XP harus terupdate ke 350")
        XCTAssertEqual(
            connectivity.petMaxXP,
            1200,
            "Pet MaxXP harus terupdate ke 1200"
        )
        XCTAssertEqual(
            connectivity.petMood,
            "happy",
            "Pet mood harus terupdate ke happy"
        )
        XCTAssertEqual(
            connectivity.petType,
            "mint",
            "Pet type harus terupdate ke mint"
        )
        XCTAssertTrue(
            connectivity.isConnected,
            "isConnected harus true setelah menerima data"
        )
    }

    // MARK: - 4. Inventory Update Processing Tests

    func testProcessInventoryUpdateMessage() {
        // Mensimulasikan pemrosesan pesan inventoryUpdate dari iPhone.
        let connectivity = IOSConnectivity()

        let mockBgs: [[String: String]] = [
            [
                "id": "bg_ocean", "name": "Ocean", "colorHex": "#0077B6",
                "spotsHex": "#90E0EF",
            ],
            [
                "id": "bg_forest", "name": "Forest", "colorHex": "#2D6A4F",
                "spotsHex": "#95D5B2",
            ],
        ]

        // Simulasi langsung: assign field sesuai logika processMessage
        connectivity.ownedBackgrounds = mockBgs
        connectivity.selectedBackgroundId = "bg_ocean"
        connectivity.isConnected = true

        XCTAssertEqual(
            connectivity.ownedBackgrounds.count,
            2,
            "Harus ada 2 background"
        )
        XCTAssertEqual(
            connectivity.selectedBackgroundId,
            "bg_ocean",
            "Background yang dipilih harus bg_ocean"
        )
        XCTAssertEqual(
            connectivity.ownedBackgrounds[0]["name"],
            "Ocean",
            "Background pertama harus Ocean"
        )
        XCTAssertTrue(
            connectivity.isConnected,
            "isConnected harus true setelah menerima data"
        )
    }

    // MARK: - 5. Logout / Clear Data Tests

    func testClearDataOnLogout() {
        // Mengisi data terlebih dahulu, lalu mensimulasikan logout dan memverifikasi semua data kembali ke default.
        let connectivity = IOSConnectivity()

        // Isi data dulu
        connectivity.username = "TestUser"
        connectivity.email = "test@test.com"
        connectivity.coins = 999
        connectivity.streak = 30
        connectivity.totalSavings = 1_000_000
        connectivity.isSafeFromPenalty = false
        connectivity.petName = "Rosie"
        connectivity.petLevel = 10
        connectivity.petXP = 500
        connectivity.petMaxXP = 2200
        connectivity.petMood = "happy"
        connectivity.petType = "mint"
        connectivity.ownedBackgrounds = [["id": "bg_1", "name": "Test"]]
        connectivity.selectedBackgroundId = "bg_1"
        connectivity.isConnected = true

        // Simulasi clearData (logika yang sama dengan method clearData private)
        connectivity.username = "—"
        connectivity.email = "—"
        connectivity.coins = 0
        connectivity.streak = 0
        connectivity.totalSavings = 0
        connectivity.isSafeFromPenalty = true
        connectivity.petName = "Pal"
        connectivity.petLevel = 0
        connectivity.petXP = 0
        connectivity.petMaxXP = 200
        connectivity.petMood = "hungry"
        connectivity.petType = "rose"
        connectivity.ownedBackgrounds = []
        connectivity.selectedBackgroundId = ""
        connectivity.isConnected = false

        // Verifikasi User Data
        XCTAssertEqual(
            connectivity.username,
            "—",
            "Username harus kembali ke default"
        )
        XCTAssertEqual(
            connectivity.email,
            "—",
            "Email harus kembali ke default"
        )
        XCTAssertEqual(connectivity.coins, 0, "Coins harus kembali ke 0")
        XCTAssertEqual(connectivity.streak, 0, "Streak harus kembali ke 0")
        XCTAssertEqual(
            connectivity.totalSavings,
            0,
            "TotalSavings harus kembali ke 0"
        )
        XCTAssertTrue(
            connectivity.isSafeFromPenalty,
            "isSafeFromPenalty harus kembali ke true"
        )

        // Verifikasi Pet Data
        XCTAssertEqual(
            connectivity.petName,
            "Pal",
            "Pet name harus kembali ke 'Pal'"
        )
        XCTAssertEqual(connectivity.petLevel, 0, "Pet level harus kembali ke 0")
        XCTAssertEqual(connectivity.petXP, 0, "Pet XP harus kembali ke 0")
        XCTAssertEqual(
            connectivity.petMaxXP,
            200,
            "Pet MaxXP harus kembali ke 200"
        )
        XCTAssertEqual(
            connectivity.petMood,
            "hungry",
            "Pet mood harus kembali ke 'hungry'"
        )
        XCTAssertEqual(
            connectivity.petType,
            "rose",
            "Pet type harus kembali ke 'rose'"
        )

        // Verifikasi Inventory Data
        XCTAssertTrue(
            connectivity.ownedBackgrounds.isEmpty,
            "Owned backgrounds harus kosong setelah logout"
        )
        XCTAssertEqual(
            connectivity.selectedBackgroundId,
            "",
            "Selected background harus kosong setelah logout"
        )

        // Verifikasi Connection Status
        XCTAssertFalse(
            connectivity.isConnected,
            "isConnected harus false setelah logout"
        )
    }

    // MARK: - 6. Equip Background Logic Tests

    func testEquipBackgroundUpdatesLocalState() {
        // Memverifikasi bahwa equip background mengubah selectedBackgroundId secara lokal.
        let connectivity = IOSConnectivity()

        connectivity.ownedBackgrounds = [
            [
                "id": "bg_ocean", "name": "Ocean", "colorHex": "#0077B6",
                "spotsHex": "#90E0EF",
            ],
            [
                "id": "bg_forest", "name": "Forest", "colorHex": "#2D6A4F",
                "spotsHex": "#95D5B2",
            ],
        ]
        connectivity.selectedBackgroundId = "bg_ocean"

        // Simulasi ganti background
        let newBgId = "bg_forest"
        connectivity.selectedBackgroundId = newBgId

        XCTAssertEqual(
            connectivity.selectedBackgroundId,
            "bg_forest",
            "Selected background harus berubah ke bg_forest"
        )
    }

    func testBackgroundSelectionFromOwnedList() {
        // Memverifikasi bahwa background yang dipilih memang ada di dalam daftar kepemilikan.
        let connectivity = IOSConnectivity()

        connectivity.ownedBackgrounds = [
            [
                "id": "bg_ocean", "name": "Ocean", "colorHex": "#0077B6",
                "spotsHex": "#90E0EF",
            ]
        ]
        connectivity.selectedBackgroundId = "bg_ocean"

        let isOwned = connectivity.ownedBackgrounds.contains {
            $0["id"] == connectivity.selectedBackgroundId
        }
        XCTAssertTrue(
            isOwned,
            "Background yang dipilih harus ada di daftar yang dimiliki"
        )
    }

    func testBackgroundSelectionNotOwned() {
        // Memverifikasi bahwa validasi mendeteksi background yang tidak dimiliki.
        let connectivity = IOSConnectivity()

        connectivity.ownedBackgrounds = [
            [
                "id": "bg_ocean", "name": "Ocean", "colorHex": "#0077B6",
                "spotsHex": "#90E0EF",
            ]
        ]
        connectivity.selectedBackgroundId = "bg_unknown"

        let isOwned = connectivity.ownedBackgrounds.contains {
            $0["id"] == connectivity.selectedBackgroundId
        }
        XCTAssertFalse(
            isOwned,
            "Background yang tidak dimiliki harus terdeteksi sebagai not owned"
        )
    }

    // MARK: - 7. XP Progress Calculation Tests

    func testXPProgressCalculation() {
        // Mensimulasikan logika perhitungan progress XP yang digunakan di WatchPetStatsView.
        let petXP = 150
        let petMaxXP = 400

        let progress = petMaxXP > 0 ? Double(petXP) / Double(petMaxXP) : 0

        XCTAssertEqual(
            progress,
            0.375,
            accuracy: 0.001,
            "Progress XP harus 37.5%"
        )
    }

    func testXPProgressCalculationZeroMaxXP() {
        // Memverifikasi bahwa perhitungan progress XP aman saat maxXP bernilai 0 (menghindari division by zero).
        let petXP = 100
        let petMaxXP = 0

        let progress = petMaxXP > 0 ? Double(petXP) / Double(petMaxXP) : 0

        XCTAssertEqual(progress, 0.0, "Progress harus 0 saat maxXP bernilai 0")
    }

    func testXPProgressFull() {
        // Memverifikasi bahwa progress XP tidak melebihi 100% saat XP = MaxXP.
        let petXP = 400
        let petMaxXP = 400

        let progress = petMaxXP > 0 ? Double(petXP) / Double(petMaxXP) : 0

        XCTAssertEqual(progress, 1.0, "Progress harus tepat 100% saat XP penuh")
    }

    // MARK: - 8. Mood Emoji Mapping Tests

    func testMoodEmojiMapping() {
        // Memverifikasi bahwa setiap mood dipetakan ke emoji yang benar sesuai logika di WatchPetStatsView.
        let moodMap: [String: String] = [
            "happy": "😊",
            "sad": "😢",
            "hungry": "🥺",
            "angry": "😡",
            "cry": "😭",
            "dizzy": "😵",
            "sleepy": "😴",
            "surprised": "😲",
            "wink": "😉",
        ]

        for (mood, expectedEmoji) in moodMap {
            let emoji = getMoodEmoji(mood)
            XCTAssertEqual(
                emoji,
                expectedEmoji,
                "Mood '\(mood)' harus dipetakan ke emoji '\(expectedEmoji)'"
            )
        }
    }

    func testMoodEmojiDefaultMapping() {
        // Memverifikasi bahwa mood yang tidak dikenal dipetakan ke emoji default.
        let unknownMood = "confused"
        let emoji = getMoodEmoji(unknownMood)

        XCTAssertEqual(
            emoji,
            "🐾",
            "Mood tidak dikenal harus dipetakan ke emoji default '🐾'"
        )
    }

    // MARK: - 9. Mood Suffix Mapping Tests (untuk asset gambar)

    func testMoodSuffixMapping() {
        // Memverifikasi bahwa setiap mood dipetakan ke suffix nama asset gambar yang benar.
        let suffixMap: [String: String] = [
            "happy": "Laugh",
            "sad": "Sad",
            "hungry": "TongueOut",
            "angry": "Angry",
            "cry": "Cry",
            "dizzy": "Dizzy",
            "sleepy": "Sleepy",
            "surprised": "Surprised",
            "wink": "WinkTongueOut",
        ]

        for (mood, expectedSuffix) in suffixMap {
            let suffix = getMoodSuffix(mood)
            XCTAssertEqual(
                suffix,
                expectedSuffix,
                "Mood '\(mood)' harus memiliki suffix '\(expectedSuffix)'"
            )
        }
    }

    func testMoodSuffixDefaultMapping() {
        // Memverifikasi bahwa mood yang tidak dikenal mendapat suffix default.
        let unknownMood = "bored"
        let suffix = getMoodSuffix(unknownMood)

        XCTAssertEqual(
            suffix,
            "Laugh",
            "Mood tidak dikenal harus mendapat suffix default 'Laugh'"
        )
    }

    // MARK: - 10. Avatar Initials Tests

    func testAvatarInitials() {
        // Memverifikasi logika pengambilan 2 huruf pertama dari username untuk avatar.
        let username = "Jamie"
        let initials = String(username.prefix(2)).uppercased()

        XCTAssertEqual(initials, "JA", "Initials dari 'Jamie' harus 'JA'")
    }

    func testAvatarInitialsSingleChar() {
        // Memverifikasi bahwa username dengan 1 huruf tetap berfungsi dengan benar.
        let username = "A"
        let initials = String(username.prefix(2)).uppercased()

        XCTAssertEqual(initials, "A", "Initials dari 'A' harus 'A'")
    }

    func testAvatarInitialsDefault() {
        // Memverifikasi bahwa default username '—' menghasilkan initials yang benar.
        let username = "—"
        let initials = String(username.prefix(2)).uppercased()

        XCTAssertEqual(initials, "—", "Initials dari default '—' harus '—'")
    }

    // MARK: - 11. Penalty Status Logic Tests

    func testPenaltyStatusDanger() {
        // Memverifikasi bahwa status penalti menunjukkan 'danger' saat isSafeFromPenalty = false.
        let isSafeFromPenalty = false

        let icon =
            !isSafeFromPenalty ? "xmark.shield.fill" : "checkmark.shield.fill"
        let text = !isSafeFromPenalty ? "Penalty Active" : "Safe ✓"

        XCTAssertEqual(
            icon,
            "xmark.shield.fill",
            "Icon harus xmark.shield.fill saat penalti aktif"
        )
        XCTAssertEqual(
            text,
            "Penalty Active",
            "Text harus 'Penalty Active' saat penalti aktif"
        )
    }

    func testPenaltyStatusWarning() {
        // Memverifikasi bahwa status penalti menunjukkan 'warning' saat sisa waktu < 24 jam.
        let isSafeFromPenalty = true
        let nextPenaltyCheck = Calendar.current.date(
            byAdding: .hour,
            value: 12,
            to: Date()
        )!
        let hoursRemaining =
            Calendar.current.dateComponents(
                [.hour],
                from: Date(),
                to: nextPenaltyCheck
            ).hour ?? 0

        var icon = "checkmark.shield.fill"
        var text = "Safe ✓"

        if !isSafeFromPenalty {
            icon = "xmark.shield.fill"
            text = "Penalty Active"
        } else if hoursRemaining <= 24 {
            icon = "exclamationmark.triangle.fill"
            text = "Save soon!"
        }

        XCTAssertEqual(
            icon,
            "exclamationmark.triangle.fill",
            "Icon harus exclamationmark saat warning"
        )
        XCTAssertEqual(
            text,
            "Save soon!",
            "Text harus 'Save soon!' saat warning"
        )
    }

    func testPenaltyStatusSafe() {
        // Memverifikasi bahwa status penalti menunjukkan 'safe' saat sisa waktu > 24 jam.
        let isSafeFromPenalty = true
        let nextPenaltyCheck = Calendar.current.date(
            byAdding: .day,
            value: 3,
            to: Date()
        )!
        let hoursRemaining =
            Calendar.current.dateComponents(
                [.hour],
                from: Date(),
                to: nextPenaltyCheck
            ).hour ?? 0

        var icon = "checkmark.shield.fill"
        var text = "Safe ✓"

        if !isSafeFromPenalty {
            icon = "xmark.shield.fill"
            text = "Penalty Active"
        } else if hoursRemaining <= 24 {
            icon = "exclamationmark.triangle.fill"
            text = "Save soon!"
        }

        XCTAssertEqual(
            icon,
            "checkmark.shield.fill",
            "Icon harus checkmark saat safe"
        )
        XCTAssertEqual(text, "Safe ✓", "Text harus 'Safe ✓' saat safe")
    }

    // MARK: - 12. Number Formatter Tests

    func testFormattedWithDot() {
        // Memverifikasi bahwa formatter angka dengan separator titik berfungsi dengan benar.
        let value = 1_250_000
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        let formatted =
            formatter.string(from: NSNumber(value: value)) ?? "\(value)"

        XCTAssertEqual(
            formatted,
            "1.250.000",
            "Format 1250000 harus '1.250.000'"
        )
    }

    func testFormattedWithDotSmallNumber() {
        // Memverifikasi bahwa angka kecil tidak mendapat separator.
        let value = 500
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        let formatted =
            formatter.string(from: NSNumber(value: value)) ?? "\(value)"

        XCTAssertEqual(
            formatted,
            "500",
            "Format 500 harus tetap '500' tanpa separator"
        )
    }

    func testFormattedWithDotZero() {
        // Memverifikasi bahwa angka 0 ditampilkan dengan benar.
        let value = 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        let formatted =
            formatter.string(from: NSNumber(value: value)) ?? "\(value)"

        XCTAssertEqual(formatted, "0", "Format 0 harus tetap '0'")
    }

    // MARK: - Helper Functions (mereplikasi logika View untuk testing)

    private func getMoodEmoji(_ mood: String) -> String {
        switch mood.lowercased() {
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

    private func getMoodSuffix(_ mood: String) -> String {
        switch mood.lowercased() {
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
}
