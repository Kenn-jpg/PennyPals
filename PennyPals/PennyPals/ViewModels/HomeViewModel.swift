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
                // Mengambil data pet dengan aman
                let fetchedPet = try? snapshot?.documents.first?.data(
                    as: PetModel.self
                )

                // --- PERBAIKAN: Pastikan update properti @Published terjadi di Main Actor ---
                Task { @MainActor in
                    self.pet = fetchedPet

                    // 📲 Forward pet data ke Apple Watch jika data tersedia
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

                // --- PERBAIKAN: Pastikan update properti @Published terjadi di Main Actor ---
                Task { @MainActor in
                    self.goal = fetchedGoal
                }
            }
    }

    // TAMBAHKAN parameter currentUser: UserModel
    func addSavings(amount: Double, currentUser: UserModel) {
        // --- PERBAIKAN: Hindari force unwrapping (!) pada ID Pet dan Goal untuk mencegah crash ---
        guard let uid = userId,
            let currentPet = pet,
            let petId = currentPet.id,
            let currentGoal = goal,
            let goalId = currentGoal.id
        else { return }

        // Update Goal
        let newGoalAmount = currentGoal.currentAmount + amount
        db.collection("goals").document(goalId).updateData([
            "currentAmount": newGoalAmount
        ])

        // Update XP & Level
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

        // 1. Update Pet menggunakan ID yang aman
        db.collection("pets").document(petId).updateData([
            "xp": newXP,
            "level": newLevel,
            "mood": "happy",
        ])

        // 2. Siapkan data tanggal aman penalti
        let nextSafeDate = Calendar.current.date(
            byAdding: .day,
            value: 2,
            to: Date()
        )!

        // 🌟 PERUBAHAN UTAMA DI SINI 🌟
        // Hitung total tabungan baru secara manual
        let newTotalSavings = currentUser.totalSavings + Int(amount)

        // Cek apakah sudah nabung hari ini (streak hanya naik 1x per hari)
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

        // 3. Gabungkan semua update
        var userUpdates: [String: Any] = [
            "isSafeFromPenalty": true,
            "nextPenaltyCheck": nextSafeDate,
            "totalSavings": newTotalSavings,  // Langsung lempar nilai bulat Int
            "lastSavingsDate": Date(),  // Selalu update tanggal terakhir nabung
        ]

        // Streak hanya naik jika belum nabung hari ini
        if !alreadySavedToday {
            userUpdates["streak"] = FieldValue.increment(Int64(1))
        }

        // 4. Jika dapat koin, tambahkan
        if totalCoinsGained > 0 {
            userUpdates["coins"] = FieldValue.increment(Int64(totalCoinsGained))
        }

        // 5. Kirim data
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

        // 1. Tandai goal lama sebagai completed (jika ada)
        if let currentGoal = goal, let goalId = currentGoal.id {
            let oldGoalRef = db.collection("goals").document(goalId)
            batch.updateData(["isCompleted": true], forDocument: oldGoalRef)
        }

        // 2. Buat goal baru
        let newGoalRef = db.collection("goals").document()
        let newGoal = GoalModel(
            userId: uid,
            itemName: itemName,
            targetAmount: targetAmount,
            currentAmount: 0,
            isCompleted: false
        )
        try? batch.setData(from: newGoal, forDocument: newGoalRef)

        // 3. Commit batch
        batch.commit()
    }

    func checkDailyPenalty() {
        // --- PERBAIKAN: Pastikan ID Pet diekstrak dengan aman di awal fungsi ---
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
                    // Cek jika level > 0 agar tidak drop di bawah 0
                    if newLevel > 0 {
                        newLevel -= 1
                        // Kembalikan sisa XP yang minus dari maxXP level sebelumnya
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

                // Menggunakan petId yang sudah tervalidasi aman
                let petRef = self.db.collection("pets").document(petId)
                batch.updateData(
                    ["xp": newXP, "level": newLevel, "mood": "sad"],
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

        // Jika pet sudah sad/penalty, jangan ditimpa dengan hungry
        if currentPet.mood == "sad" { return }

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

        // Jika belum nabung hari ini dan pet belum lapar, buat jadi lapar
        if !alreadySavedToday && currentPet.mood != "hungry" {
            db.collection("pets").document(petId).updateData([
                "mood": "hungry"
            ])
        }
    }
}
