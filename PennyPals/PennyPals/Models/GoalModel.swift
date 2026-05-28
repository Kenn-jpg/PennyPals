//
//  GoalModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseFirestore
import Foundation

struct GoalModel: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var itemName: String
    var targetAmount: Double
    var currentAmount: Double
    var isCompleted: Bool
}
