//
//  GoalModel.swift
//  PennyPals
//
//  Created by student on 28/05/26.
//

import Foundation
import FirebaseFirestore

struct GoalModel: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var itemName: String
    var targetAmount: Double
    var currentAmount: Double
    var isCompleted: Bool
}
