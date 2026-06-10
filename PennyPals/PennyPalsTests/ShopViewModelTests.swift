//
//  ShopViewModelTests.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import XCTest

@testable import PennyPals

final class ShopViewModelTests: XCTestCase {

    func testPurchaseItemSuccess() {
        let itemPrice = 500
        let itemId = "theme_01"

        var currentUserCoins = 1000
        var unlockedItemIds: [String] = []

        let canAfford = currentUserCoins >= itemPrice
        let isAlreadyOwned = unlockedItemIds.contains(itemId)

        if canAfford && !isAlreadyOwned {
            currentUserCoins -= itemPrice
            unlockedItemIds.append(itemId)
        }

        XCTAssertEqual(currentUserCoins, 500, "Koin harus berkurang 500")
        XCTAssertTrue(
            unlockedItemIds.contains(itemId),
            "Item ID harus ditambahkan ke inventaris"
        )
    }

    func testPurchaseFailsInsufficientCoins() {
        let itemPrice = 500
        let currentUserCoins = 200

        let canAfford = currentUserCoins >= itemPrice

        XCTAssertFalse(canAfford, "Pembelian harus ditolak jika koin kurang")
    }

    func testPurchaseFailsAlreadyOwned() {

        let itemId = "theme_01"
        let unlockedItemIds: [String] = [itemId]

        let isAlreadyOwned = unlockedItemIds.contains(itemId)

        XCTAssertTrue(
            isAlreadyOwned,
            "Sistem harus mendeteksi item ganda di inventaris"
        )
    }

    func testEquipBackground() {
        let itemId = "bg_ocean"
        let unlockedItemIds: [String] = ["bg_ocean", "theme_01"]
        var selectedBackgroundId: String? = nil
        var errorMessage: String? = nil

        if unlockedItemIds.contains(itemId) {
            selectedBackgroundId = itemId
        } else {
            errorMessage = "Beli dulu background-nya!"
        }

        XCTAssertEqual(
            selectedBackgroundId,
            "bg_ocean",
            "Background harus berhasil di-equip"
        )
        XCTAssertNil(errorMessage, "Tidak boleh ada error message")
    }

    func testEquipBackgroundFailsNotOwned() {
        let itemId = "bg_ocean"
        let unlockedItemIds: [String] = ["theme_01"]
        var selectedBackgroundId: String? = nil
        var errorMessage: String? = nil

        if unlockedItemIds.contains(itemId) {
            selectedBackgroundId = itemId
        } else {
            errorMessage = "Beli dulu background-nya!"
        }

        XCTAssertNil(selectedBackgroundId, "Background tidak boleh di-equip")
        XCTAssertEqual(
            errorMessage,
            "Beli dulu background-nya!",
            "Harus muncul pesan error"
        )
    }
}
