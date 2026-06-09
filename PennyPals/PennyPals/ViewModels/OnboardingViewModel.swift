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

// ViewModel untuk mengelola proses onboarding pengguna baru di PennyPals.
// Menangani pembuatan data pet awal, target wishlist, dan inisialisasi status user.
@MainActor
class OnboardingViewModel: ObservableObject {
    
    // MARK: - Properties
    private var db = Firestore.firestore()

    // MARK: - 1. Onboarding Process

    // Menyelesaikan proses onboarding dan menyimpan semua data konfigurasi awal ke Firestore
    func completeOnboarding(
        initialSavings: Double,
        targetAmount: Double,
        eggType: String,
        petName: String,
        wishlistName: String,
        petType: String
    ) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        guard targetAmount > 0, initialSavings < targetAmount else {
            print("Error: Target tidak valid atau tabungan awal sudah melampaui target.")
            return
        }

        // Membuat model peliharaan dengan tipe hewan yang didapat (bukan tipe telurnya)
        let newPet = PetModel(
            userId: uid,
            name: petName,
            type: petType,  // Menyimpan "Cat", "Dog", dsb. ke database
            xp: 0,
            level: 1,
            mood: "hungry"
        )

        // Membuat model target wishlist pertama
        let initialGoal = GoalModel(
            userId: uid,
            itemName: wishlistName,
            targetAmount: targetAmount,
            currentAmount: initialSavings,
            isCompleted: false
        )

        do {
            // 1. Simpan data pet & goal ke Firestore
            try db.collection("pets").addDocument(from: newPet)
            try db.collection("goals").addDocument(from: initialGoal)

            // 2. Simpan transaksi tabungan awal jika lebih dari 0
            if initialSavings > 0 {
                let initialTx = TransactionModel(
                    userId: uid,
                    amount: initialSavings,
                    date: Date(),
                    type: .deposit
                )
                try db.collection("transactions").addDocument(from: initialTx)
            }

            // 3. Update status user
            try await db.collection("users").document(uid).updateData([
                "isOnboarded": true,
                "totalSavings": initialSavings,
            ])

        } catch {
            print("Onboarding error: \(error.localizedDescription)")
        }
    }
}
