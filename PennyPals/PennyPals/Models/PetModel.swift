//
//  PetModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseFirestore
import Foundation

// Merepresentasikan status hewan peliharaan virtual yang menjadi indikator progres menabung pengguna.
struct PetModel: Identifiable, Codable, Equatable {
    // MARK: - Properties

    // ID unik dokumen di Firebase Firestore.
    @DocumentID var id: String?

    // ID dari pengguna yang memelihara pet ini.
    var userId: String

    // Nama panggilan yang diberikan pengguna untuk peliharaannya.
    var name: String

    // Jenis ras atau varian hewan peliharaan (contoh: "Cat", "Dog", "Owl", dll).
    var type: String

    // Poin pengalaman saat ini pada level yang sedang berjalan.
    var xp: Int

    // Tingkat evolusi atau pertumbuhan hewan peliharaan saat ini.
    var level: Int

    // Kondisi emosional dari pet untuk merender grafik UI (contoh: "happy", "hungry", "sad").
    var mood: String

    // Batas maksimal XP yang dibutuhkan untuk naik ke level selanjutnya.
    // Rumus dinamis: Level 0 -> 200 XP, Level 1 -> 400 XP, Level 2 -> 600 XP, dst. (Tanpa batas maksimal level).
    var maxXP: Int {
        return (level + 1) * 200
    }
}
