//
//  ShopItemModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseFirestore
import Foundation

// Merepresentasikan sebuah produk virtual yang bisa dibeli pengguna di dalam toko (Shop).
struct ShopItemModel: Identifiable, Codable, Equatable {
    // MARK: - Properties

    // ID unik dokumen di Firebase Firestore.
    @DocumentID var id: String?

    // Nama kosmetik atau barang virtual.
    var name: String

    // Kelompok kategori barang (contoh: "Accessories", "Backgrounds").
    var category: String

    // Harga item yang harus dibayar menggunakan koin virtual (`coins`).
    var price: Int

    // Properti kode warna Hex opsional, umumnya digunakan untuk kustomisasi warna telur atau warna dasar background.
    var colorHex: String?

    // Properti kode warna Hex opsional untuk memberikan pola/corak pada telur atau background.
    var spotsHex: String?

    // Nama file gambar aset yang dipanggil dari Xcode Assets Catalog (contoh: "tshirt.fill").
    var imageName: String?

    // Menandakan apakah latar belakang menggunakan efek warna degradasi (gradient).
    var isGradient: Bool?

    // Properti kode warna Hex ujung/akhir jika properti `isGradient` bernilai true.
    var endColorHex: String?
}
