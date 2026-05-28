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
        // Logika untuk mengurangi XP jika user tidak menabung sesuai target waktu
        // Fungsi ini bisa dipanggil setiap kali aplikasi dibuka (di onAppear)
    }
    
    private func rewardCoins(amount: Int) {
        guard let uid = userId else { return }
        db.collection("users").document(uid).updateData([
            "coins": FieldValue.increment(Int64(amount))
        ])
    }
}
