//
//  GoalModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseFirestore
import Foundation

/// Mewakili rencana target finansial (wishlist) jangka pendek atau panjang dari pengguna.
struct GoalModel: Identifiable, Codable, Equatable {

    /// ID unik dokumen di Firebase Firestore.
    @DocumentID var id: String?

    /// ID pengguna yang memiliki target tabungan ini.
    var userId: String

    /// Nama benda atau impian yang ingin dibeli pengguna menggunakan tabungannya.
    var itemName: String

    /// Total nominal uang yang wajib terkumpul agar target selesai.
    var targetAmount: Double

    /// Jumlah saldo yang saat ini telah berhasil dialokasikan untuk target ini.
    var currentAmount: Double

    /// Status apakah pengguna telah berhasil mencapai 100% nominal targetnya.
    var isCompleted: Bool
}
