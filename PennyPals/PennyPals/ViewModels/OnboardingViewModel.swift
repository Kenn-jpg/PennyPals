//
//  OnboardingViewModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

internal import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation

@MainActor
class OnboardingViewModel: ObservableObject {
    private var db = Firestore.firestore()

    // --- TAMBAHAN BARU: Tambahkan parameter targetAmount ---
    func completeOnboarding(
        initialSavings: Double,
        targetAmount: Double,
        eggType: String,
        petName: String,
        wishlistName: String
    ) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let newPet = PetModel(
            userId: uid,
            name: petName,
            type: eggType,
            xp: 0,
            level: 1,
            mood: "hungry"
        )

        let initialGoal = GoalModel(
            userId: uid,
            itemName: wishlistName,
            targetAmount: targetAmount,  // --- Gunakan input targetAmount di sini ---
            currentAmount: initialSavings,
            isCompleted: false
        )

        do {
            try db.collection("pets").addDocument(from: newPet)
            try db.collection("goals").addDocument(from: initialGoal)
            let initialTx = TransactionModel(
                userId: uid,
                amount: initialSavings,
                date: Date(),
                type: .deposit
            )
            try db.collection("transactions").addDocument(from: initialTx)

            try await db.collection("users").document(uid).updateData([
                "isOnboarded": true,
                "totalSavings": initialSavings,  // 👈 Tambahkan baris ini
            ])

        } catch {
            print("Onboarding error: \(error.localizedDescription)")
        }
    }
}
