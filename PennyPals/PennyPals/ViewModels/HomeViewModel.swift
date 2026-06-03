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

    // Properti untuk menghitung frekuensi buka modal (memicu dizzy)
    private var modalOpenCount = 0
    private var lastModalOpenTime = Date()

    init() {
        fetchPetData()
        fetchGoalData()
    }

    func fetchPetData() {
        guard let uid = userId else { return }
        db.collection("pets").whereField("userId", isEqualTo: uid)
            .addSnapshotListener { snapshot, _ in
                let fetchedPet = try? snapshot?.documents.first?.data(
                    as: PetModel.self
                )

                Task { @MainActor in
                    self.pet = fetchedPet

                    if let pet = fetchedPet {
                        PhoneConnectivity.shared.sendPetToWatch(
                            name: pet.name,
                            level: pet.level,
                            xp: pet.xp,
                            maxXP: pet.maxXP,
                            mood: pet.mood,
                            type: pet.type
                        )
                    }
                }
            }
    }

    func fetchGoalData() {
        guard let uid = userId else { return }
        db.collection("goals")
            .whereField("userId", isEqualTo: uid)
            .whereField("isCompleted", isEqualTo: false)
            .limit(to: 1)
            .addSnapshotListener { snapshot, _ in
                let fetchedGoal = try? snapshot?.documents.first?.data(
                    as: GoalModel.self
                )

                Task { @MainActor in
                    self.goal = fetchedGoal
                }
            }
    }

    func addSavings(amount: Double, currentUser: UserModel) {
        guard let uid = userId,
            let currentPet = pet,
            let petId = currentPet.id,
            let currentGoal = goal,
            let goalId = currentGoal.id
        else { return }

        let newGoalAmount = currentGoal.currentAmount + amount
        db.collection("goals").document(goalId).updateData([
            "currentAmount": newGoalAmount
        ])

        let gainedXP = Int(amount / 1000)
        var newXP = currentPet.xp + gainedXP
        var newLevel = currentPet.level
        var totalCoinsGained = 0

        var currentMaxXP = (newLevel + 1) * 200
        while newXP >= currentMaxXP {
            newXP -= currentMaxXP
            newLevel += 1
            totalCoinsGained += 50 + (newLevel * 10)
            currentMaxXP = (newLevel + 1) * 200
        }

        // 🌟 TRIGGER SURPRISED: Jika nabung >= Rp 500.000 mendadak terkejut
        let newMood = amount >= 500_000 ? "surprised" : "happy"

        db.collection("pets").document(petId).updateData([
            "xp": newXP,
            "level": newLevel,
            "mood": newMood,
        ])

        let nextSafeDate = Calendar.current.date(
            byAdding: .day,
            value: 2,
            to: Date()
        )!

        let newTotalSavings = currentUser.totalSavings + Int(amount)

        let today = Calendar.current.startOfDay(for: Date())
        let alreadySavedToday: Bool
        if let lastSave = currentUser.lastSavingsDate {
            alreadySavedToday = Calendar.current.isDate(
                lastSave,
                inSameDayAs: today
            )
        } else {
            alreadySavedToday = false
        }

        var userUpdates: [String: Any] = [
            "isSafeFromPenalty": true,
            "nextPenaltyCheck": nextSafeDate,
            "totalSavings": newTotalSavings,
            "lastSavingsDate": Date(),
        ]

        if !alreadySavedToday {
            userUpdates["streak"] = FieldValue.increment(Int64(1))
        }

        if totalCoinsGained > 0 {
            userUpdates["coins"] = FieldValue.increment(Int64(totalCoinsGained))
        }

        db.collection("users").document(uid).updateData(userUpdates)

        let tx = TransactionModel(
            userId: uid,
            amount: amount,
            date: Date(),
            type: .deposit
        )
        try? db.collection("transactions").addDocument(from: tx)
    }

    func setNewGoal(itemName: String, targetAmount: Double) {
        guard let uid = userId else { return }
        let batch = db.batch()

        if let currentGoal = goal, let goalId = currentGoal.id {
            let oldGoalRef = db.collection("goals").document(goalId)
            batch.updateData(["isCompleted": true], forDocument: oldGoalRef)
        }

        let newGoalRef = db.collection("goals").document()
        let newGoal = GoalModel(
            userId: uid,
            itemName: itemName,
            targetAmount: targetAmount,
            currentAmount: 0,
            isCompleted: false
        )
        try? batch.setData(from: newGoal, forDocument: newGoalRef)
        batch.commit()
    }

    func checkDailyPenalty() {
        guard let uid = userId,
            let currentPet = pet,
            let petId = currentPet.id
        else { return }

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
                    if newLevel > 0 {
                        newLevel -= 1
                        let previousMaxXP = (newLevel + 1) * 200
                        newXP = previousMaxXP + newXP
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

                // 🌟 TRIGGER CRY vs SAD: Jika level turun, menangis. Jika level aman, cuma sedih.
                let penaltyMood = (newLevel < currentPet.level) ? "cry" : "sad"

                let batch = self.db.batch()
                let userRef = self.db.collection("users").document(uid)
                batch.updateData(
                    [
                        "streak": 0,
                        "isSafeFromPenalty": false,
                        "nextPenaltyCheck": nextCheck,
                    ],
                    forDocument: userRef
                )

                let petRef = self.db.collection("pets").document(petId)
                batch.updateData(
                    ["xp": newXP, "level": newLevel, "mood": penaltyMood],
                    forDocument: petRef
                )

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

    func checkDailyHunger(currentUser: UserModel) {
        guard let currentPet = pet, let petId = currentPet.id else { return }

        // Jika pet sedang dihukum (sedih/menangis), biarkan status penalti tetap berjalan
        if currentPet.mood == "sad" || currentPet.mood == "cry" { return }

        let today = Calendar.current.startOfDay(for: Date())
        let alreadySavedToday: Bool
        let hoursSinceLastSave: Int

        if let lastSave = currentUser.lastSavingsDate {
            alreadySavedToday = Calendar.current.isDate(
                lastSave,
                inSameDayAs: today
            )
            hoursSinceLastSave =
                Calendar.current.dateComponents(
                    [.hour],
                    from: lastSave,
                    to: Date()
                ).hour ?? 0
        } else {
            alreadySavedToday = false
            hoursSinceLastSave = 0
        }

        let currentHour = Calendar.current.component(.hour, from: Date())
        let isLateNight = currentHour >= 22 || currentHour < 5

        if !alreadySavedToday {
            let newMood = hoursSinceLastSave > 24 ? "angry" : "hungry"
            if currentPet.mood != newMood {
                db.collection("pets").document(petId).updateData([
                    "mood": newMood
                ])
            }
        } else if isLateNight {
            // 🌟 PERBAIKAN: Jangan timpa mood spesial (surprised/wink) menjadi sleepy secara instan
            let protectedMoods = ["surprised", "wink"]
            if !protectedMoods.contains(currentPet.mood)
                && currentPet.mood != "sleepy"
            {
                db.collection("pets").document(petId).updateData([
                    "mood": "sleepy"
                ])
            }
        } else {
            // Mengembalikan ke happy secara tegas jika siang hari dan SUDAH menabung
            // Pengecualian hanya untuk "surprised" atau "wink" agar ekspresi bahagianya bertahan
            let allowedMoods = ["happy", "surprised", "wink"]
            if !allowedMoods.contains(currentPet.mood) {
                db.collection("pets").document(petId).updateData([
                    "mood": "happy"
                ])
            }
        }
    }

    func registerModalOpen() {
        guard let currentPet = pet, let petId = currentPet.id else { return }
        if currentPet.mood == "sad" || currentPet.mood == "cry" { return }

        let now = Date()
        if now.timeIntervalSince(lastModalOpenTime) < 30 {
            modalOpenCount += 1
        } else {
            modalOpenCount = 1
        }

        lastModalOpenTime = now

        if modalOpenCount >= 4 {
            db.collection("pets").document(petId).updateData(["mood": "dizzy"])
            modalOpenCount = 0
        }
    }
}
