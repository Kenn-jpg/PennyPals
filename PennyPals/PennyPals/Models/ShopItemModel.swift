//
//  ShopItemModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseFirestore
import Foundation

struct ShopItemModel: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var category: String  // "Eggs", "Accessories", "Backgrounds", "Food"
    var price: Int

    // Properti khusus untuk visual telur (opsional, tergantung kategori)
    var colorHex: String?
    var spotsHex: String?

    // Properti khusus untuk aksesoris/tema
    var imageName: String?
}
