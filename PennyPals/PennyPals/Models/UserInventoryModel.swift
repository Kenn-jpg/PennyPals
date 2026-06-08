//
//  UserInventoryModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseFirestore
import Foundation

// Mendata seluruh kepemilikan aset virtual (seperti aksesoris dan background) yang dimiliki seorang pengguna.
struct UserInventoryModel: Identifiable, Codable, Equatable {
    // MARK: - Properties

    // ID unik dokumen di Firebase Firestore.
    @DocumentID var id: String?

    // ID pengguna pemilik inventori ini.
    var userId: String

    // Kumpulan array berisi ID dari `ShopItemModel` yang telah berhasil dibeli (unlocked).
    var unlockedItemIds: [String]

    // ID dari background yang saat ini sedang aktif atau dipakai di HomeView.
    var selectedBackgroundId: String?

    // ID dari aksesoris yang saat ini sedang aktif atau dipakai di HomeView.
    var selectedAccessoryId: String?
}
