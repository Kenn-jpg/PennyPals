//
//  OnboardingViewModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation

@MainActor
class OnboardingViewModel: ObservableObject {
    private var db = Firestore.firestore()
    private var userId: String? { Auth.auth().currentUser?.uid }

    func completeOnboarding(
        initialSavings: Double,
        eggType: String,
        petName: String
    ) async {
        guard let uid = userId else { return }

        // 1. Buat Pet Baru
        let newPet = PetModel(
            userId: uid,
            name: petName,
            type: eggType,
            xp: 0,
            level: 1,
            mood: "hungry"
        )

        // 2. Buat Wishlist/Goal Awal (Kosong, bisa diisi nanti)
        let initialGoal = GoalModel(
            userId: uid,
            itemName: "My First Goal",
            targetAmount: 5_000_000,  // Default 5jt
            currentAmount: initialSavings,
            isCompleted: false
        )

        do {
            try db.collection("pets").addDocument(from: newPet)
            try db.collection("goals").addDocument(from: initialGoal)

            // Catat transaksi awal
            let initialTx = TransactionModel(
                userId: uid,
                amount: initialSavings,
                date: Date(),
                type: .deposit
            )
            try db.collection("transactions").addDocument(from: initialTx)

        } catch {
            print("Error saving onboarding data: \(error.localizedDescription)")
        }
    }
}
