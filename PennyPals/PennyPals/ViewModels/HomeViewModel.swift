//
//  HomeViewModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

internal import Combine
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var pet: PetModel?
    @Published var goal: GoalModel?

    private var db = Firestore.firestore()
    private var userId: String? { Auth.auth().currentUser?.uid }

    init() {
        fetchPetData()
        fetchGoalData()
    }

    func fetchPetData() {
        guard let uid = userId else { return }
        db.collection("pets").whereField("userId", isEqualTo: uid)
            .addSnapshotListener { snapshot, _ in
                self.pet = try? snapshot?.documents.first?.data(
                    as: PetModel.self
                )
            }
    }

    func fetchGoalData() {
        guard let uid = userId else { return }
        db.collection("goals").whereField("userId", isEqualTo: uid).limit(to: 1)
            .addSnapshotListener { snapshot, _ in
                self.goal = try? snapshot?.documents.first?.data(
                    as: GoalModel.self
                )
            }
    }

    func addSavings(amount: Double) {
        guard let uid = userId, let currentPet = pet, let currentGoal = goal
        else { return }

        // Update Goal
        let newGoalAmount = currentGoal.currentAmount + amount
        db.collection("goals").document(currentGoal.id!).updateData([
            "currentAmount": newGoalAmount
        ])

        // Update XP & Level
        let gainedXP = Int(amount / 1000)
        var newXP = currentPet.xp + gainedXP
        var newLevel = currentPet.level

        if newXP >= currentPet.maxXP {
            newLevel += 1
            newXP = newXP - currentPet.maxXP
            db.collection("users").document(uid).updateData([
                "coins": FieldValue.increment(Int64(500))
            ])
        }

        db.collection("pets").document(currentPet.id!).updateData([
            "xp": newXP,
            "level": newLevel,
            "mood": "happy",
        ])

        // Update Streak & Penalty status
        let nextSafeDate = Calendar.current.date(
            byAdding: .day,
            value: 2,
            to: Date()
        )!
        db.collection("users").document(uid).updateData([
            "streak": FieldValue.increment(Int64(1)),
            "isSafeFromPenalty": true,
            "nextPenaltyCheck": nextSafeDate,
        ])

        let tx = TransactionModel(
            userId: uid,
            amount: amount,
            date: Date(),
            type: .deposit
        )
        try? db.collection("transactions").addDocument(from: tx)

        // Revert mood to hungry after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.db.collection("pets").document(currentPet.id!).updateData([
                "mood": "hungry"
            ])
        }
    }

    func checkDailyPenalty() {
        guard let uid = userId, let currentPet = pet else { return }
        db.collection("users").document(uid).getDocument {
            [weak self] snapshot, _ in
            guard let self = self,
                let user = try? snapshot?.data(as: UserModel.self)
            else { return }

            let now = Date()
            if now >= user.nextPenaltyCheck {
                var newXP = currentPet.xp - 200
                var newLevel = currentPet.level

                if newXP < 0 {
                    if newLevel > 1 {
                        newLevel -= 1
                        newXP = (newLevel * 1000) + newXP
                    } else {
                        newXP = 0
                    }
                }

                guard
                    let nextCheck = Calendar.current.date(
                        byAdding: .day,
                        value: 1,
                        to: now
                    )
                else { return }

                let batch = self.db.batch()
                let userRef = self.db.collection("users").document(uid)
                batch.updateData(
                    [
                        "streak": 0, "isSafeFromPenalty": false,
                        "nextPenaltyCheck": nextCheck,
                    ],
                    forDocument: userRef
                )

                if let petId = currentPet.id {
                    let petRef = self.db.collection("pets").document(petId)
                    batch.updateData(
                        ["xp": newXP, "level": newLevel, "mood": "sad"],
                        forDocument: petRef
                    )
                }

                let txRef = self.db.collection("transactions").document()
                try? batch.setData(
                    from: TransactionModel(
                        id: txRef.documentID,
                        userId: uid,
                        amount: 0,
                        date: now,
                        type: .penalty
                    ),
                    forDocument: txRef
                )
                batch.commit()
            }
        }
    }
}
