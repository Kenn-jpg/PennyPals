//
//  TransactionModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseFirestore
import Foundation

// Merepresentasikan transaksi keuangan yang dicatat oleh pengguna,
// baik itu menabung, pengeluaran, maupun pengurangan saldo akibat penalti.
struct TransactionModel: Identifiable, Codable, Equatable {
    // MARK: - Properties

    // ID unik dokumen di Firebase Firestore.
    @DocumentID var id: String?

    // ID pengguna pemilik transaksi ini.
    var userId: String

    // Nominal uang yang ditransaksikan.
    var amount: Double

    // Tanggal dan waktu transaksi dilakukan.
    var date: Date

    // Jenis kategori transaksi (pemasukan/pengeluaran/penalti).
    var type: TransactionType

    // Kategori valid untuk sebuah transaksi.
    enum TransactionType: String, Codable, Equatable {
        case deposit
        case penalty
        case expense
    }
}
