//
//  UserModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseFirestore
import Foundation

/// Menyimpan informasi profil utama, metrik gamifikasi, dan status finansial pengguna secara keseluruhan.
struct UserModel: Identifiable, Codable, Equatable {

    /// ID unik dokumen di Firebase Firestore (diselaraskan dengan UID FirebaseAuth).
    @DocumentID var id: String?

    /// Nama tampilan dari pengguna.
    var username: String

    /// Alamat email aktif milik pengguna.
    var email: String

    /// Jumlah koin virtual yang dimiliki untuk berbelanja di Shop.
    var coins: Int

    /// Jumlah hari berturut-turut pengguna disiplin menabung (Streak).
    var streak: Int

    /// Waktu terakhir kali pengguna login ke dalam aplikasi.
    var lastLoginDate: Date

    /// Waktu saat akun pengguna pertama kali dibuat.
    var createdAt: Date

    /// Total keseluruhan saldo uang yang telah berhasil ditabung.
    var totalSavings: Int

    /// Menandakan apakah pengguna saat ini berstatus aman dari penalti poin XP.
    var isSafeFromPenalty: Bool

    /// Batas waktu bagi sistem untuk mengecek konsistensi menabung pengguna berikutnya.
    var nextPenaltyCheck: Date

    /// Menandai apakah pengguna baru telah menyelesaikan alur perkenalan (Onboarding).
    var isOnboarded: Bool?

    /// Waktu terakhir kali pengguna menabung (digunakan untuk mendeteksi streak harian).
    var lastSavingsDate: Date?

    /// ID Background yang sedang dipakai user (jika nil, aplikasi akan memakai background default).
    var equippedBackground: String?

    /// ID Aksesoris yang sedang dipakai user (jika nil, pet tidak menggunakan aksesoris).
    var equippedAccessory: String?
}
