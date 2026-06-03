//
//  TransactionModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseFirestore
import Foundation

struct TransactionModel: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var amount: Double
    var date: Date
    var type: TransactionType

    enum TransactionType: String, Codable {
        case deposit
        case penalty
        case expense
    }
}
