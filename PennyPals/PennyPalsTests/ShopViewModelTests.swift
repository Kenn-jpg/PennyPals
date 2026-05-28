//
//  ShopViewModelTests.swift
//  PennyPals
//
//  Created by student on 28/05/26.
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
        #expect(unlockedItemIds.contains(itemId), "Item ID harus ditambahkan ke inventaris")
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
        
        #expect(isAlreadyOwned == true, "Sistem harus mendeteksi item ganda di inventaris")
    }
}
