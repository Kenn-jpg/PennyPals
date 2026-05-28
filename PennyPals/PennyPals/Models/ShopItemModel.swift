//
//  ShopItemModel.swift
//  PennyPals
//
//  Created by student on 28/05/26.
//


import Foundation
import FirebaseFirestore

struct ShopItemModel: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var category: String // "Eggs", "Accessories", "Backgrounds", "Food"
    var price: Int
    
    // Properti khusus untuk visual telur (opsional, tergantung kategori)
    var colorHex: String?
    var spotsHex: String?
    
    // Properti khusus untuk aksesoris/tema
    var imageName: String?
}