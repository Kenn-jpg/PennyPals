//
//  UserInventoryModel.swift
//  PennyPals
//
//  Created by Keane Juan Suryanto on 28/05/26.
//

import FirebaseFirestore
import Foundation

struct UserInventoryModel: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var unlockedItemIds: [String]  // Menyimpan ID barang dari ShopItemModel
}
