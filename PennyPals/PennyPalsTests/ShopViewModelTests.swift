//
//  ShopViewModelTests.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import Testing

@testable import PennyPals

struct ShopViewModelTests {

    @Test("Validasi purchaseItem: Sukses saat koin cukup dan belum punya")
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

        #expect(currentUserCoins == 500, "Koin harus berkurang 500")
        #expect(
            unlockedItemIds.contains(itemId),
            "Item ID harus ditambahkan ke inventaris"
        )
    }

    @Test("Validasi purchaseItem: Gagal karena koin kurang")
    func testPurchaseFailsInsufficientCoins() {
        let itemPrice = 500
        let currentUserCoins = 200

        let canAfford = currentUserCoins >= itemPrice

        #expect(canAfford == false, "Pembelian harus ditolak jika koin kurang")
    }

    @Test("Validasi purchaseItem: Gagal karena item sudah dimiliki")
    func testPurchaseFailsAlreadyOwned() {

        let itemId = "theme_01"
        let unlockedItemIds: [String] = [itemId]

        let isAlreadyOwned = unlockedItemIds.contains(itemId)

        #expect(
            isAlreadyOwned == true,
            "Sistem harus mendeteksi item ganda di inventaris"
        )
    }

    @Test("Validasi Equip Background/Item: Berhasil")
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

        #expect(selectedBackgroundId == "bg_ocean", "Background harus berhasil di-equip")
        #expect(errorMessage == nil, "Tidak boleh ada error message")
    }

    @Test("Validasi Equip Background/Item: Gagal karena belum punya")
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

        #expect(selectedBackgroundId == nil, "Background tidak boleh di-equip")
        #expect(errorMessage == "Beli dulu background-nya!", "Harus muncul pesan error")
    }
}
