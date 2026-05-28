//
//  HomeViewModel.swift
//  PennyPals
//
//  Created by student on 28/05/26.
//

internal import Combine
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

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
        db.collection("pets").whereField("userId", isEqualTo: uid).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents, !documents.isEmpty else { return }
            self.pet = try? documents.first?.data(as: PetModel.self)
        }
    }
    
    func fetchGoalData() {
        guard let uid = userId else { return }
        db.collection("goals").whereField("userId", isEqualTo: uid).limit(to: 1).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents, !documents.isEmpty else { return }
            self.goal = try? documents.first?.data(as: GoalModel.self)
        }
    }
    
    // MARK: - Gamification Logic (Menabung & XP)
    func addSavings(amount: Double) {
        guard let uid = userId, let currentPet = pet, let currentGoal = goal else { return }
        
        // 1. Update Uang di Wishlist
        let newGoalAmount = currentGoal.currentAmount + amount
        db.collection("goals").document(currentGoal.id!).updateData([
            "currentAmount": newGoalAmount
        ])
        
        // 2. Tambah XP Pet (Contoh: 10 XP untuk setiap Rp 10.000)
        let gainedXP = Int(amount / 1000)
        var newXP = currentPet.xp + gainedXP
        var newLevel = currentPet.level
        var newMood = "happy"
        
        // Logika Naik Level
        if newXP >= currentPet.maxXP {
            newLevel += 1
            newXP = newXP - currentPet.maxXP
            // Bisa tambahkan logika reward Koin di sini saat naik level
            rewardCoins(amount: 500)
        }
        
        // Update Pet di Firestore
        db.collection("pets").document(currentPet.id!).updateData([
            "xp": newXP,
            "level": newLevel,
            "mood": newMood
        ])
        
        // 3. Catat Riwayat Transaksi
        let transaction = TransactionModel(userId: uid, amount: amount, date: Date(), type: .deposit)
        try? db.collection("transactions").addDocument(from: transaction)
    }
    
    // MARK: - Penalty Mechanism
        func checkDailyPenalty() {
            guard let uid = userId, let currentPet = pet else { return }
            
            // Ambil data user terbaru untuk mengecek nextPenaltyCheck
            db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
                guard let self = self, let document = snapshot, let user = try? document.data(as: UserModel.self) else { return }
                
                let now = Date()
                
                // Cek apakah waktu sekarang sudah melewati batas deadline menabung pengguna
                if now >= user.nextPenaltyCheck {
                    
                    // 1. Atur Logika Pengurangan XP
                    let penaltyXP = 200 // Jumlah hukuman pengurangan XP (Bisa disesuaikan)
                    var newXP = currentPet.xp - penaltyXP
                    var newLevel = currentPet.level
                    var newMood = "sad" // Pet berubah menjadi sedih karena diabaikan
                    
                    // 2. Logika Demote (Turun Level) jika XP di bawah 0
                    if newXP < 0 {
                        if newLevel > 1 {
                            newLevel -= 1
                            // XP mengambil sisa dari batas max level sebelumnya
                            let maxXPForNewLevel = newLevel * 1000
                            newXP = maxXPForNewLevel + newXP
                        } else {
                            // Mentok di level 1, XP tidak bisa lebih kecil dari 0
                            newXP = 0
                        }
                    }
                    
                    // 3. Set ulang tenggat waktu penalti berikutnya (misal: beri toleransi 1 hari lagi ke depan)
                    guard let nextCheck = Calendar.current.date(byAdding: .day, value: 1, to: now) else { return }
                    
                    // Gunakan Firebase Batch agar update data User dan Pet terjadi bersamaan
                    let batch = self.db.batch()
                    
                    // Update Firestore - Koleksi Users: Reset streak karena bolong menabung
                    let userRef = self.db.collection("users").document(uid)
                    batch.updateData([
                        "streak": 0,
                        "isSafeFromPenalty": false,
                        "nextPenaltyCheck": nextCheck
                    ], forDocument: userRef)
                    
                    // Update Firestore - Koleksi Pets: Terapkan hukuman XP dan mood
                    if let petId = currentPet.id {
                        let petRef = self.db.collection("pets").document(petId)
                        batch.updateData([
                            "xp": newXP,
                            "level": newLevel,
                            "mood": newMood
                        ], forDocument: petRef)
                    }
                    
                    // Opsional: Catat riwayat penalti ke dalam transaksi
                    let transactionRef = self.db.collection("transactions").document()
                    let penaltyTx = TransactionModel(id: transactionRef.documentID, userId: uid, amount: 0, date: now, type: .penalty)
                    try? batch.setData(from: penaltyTx, forDocument: transactionRef)
                    
                    // Eksekusi ke database
                    batch.commit { error in
                        if let error = error {
                            print("Gagal menerapkan penalti: \(error.localizedDescription)")
                        } else {
                            print("Penalti harian berhasil diterapkan! Streak direset ke 0.")
                        }
                    }
                }
            }
        }
    
    private func rewardCoins(amount: Int) {
        guard let uid = userId else { return }
        db.collection("users").document(uid).updateData([
            "coins": FieldValue.increment(Int64(amount))
        ])
    }
}
