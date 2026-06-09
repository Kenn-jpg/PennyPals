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

/// ViewModel untuk mengelola alur pendaftaran perkenalan pengguna baru (Onboarding Setup).
/// Bertanggung jawab menginisialisasi entitas awal hewan virtual, instansiasi wishlist pertama, dan pencatatan transaksi perdana.
@MainActor
class OnboardingViewModel: ObservableObject {

    private var db = Firestore.firestore()

    /// Menyelesaikan proses onboarding dengan melakukan batch commit/instansiasi data relasional awal pengguna baru secara paralel ke Firestore.
    /// - Parameters:
    ///   - initialSavings: Saldo tabungan awal yang langsung disisihkan oleh pengguna.
    ///   - targetAmount: Batas total uang yang ditargetkan untuk rencana wishlist pertama.
    ///   - eggType: Jenis visual telur yang dipilih pengguna.
    ///   - petName: Nama kustom pet virtual yang diberikan pengguna.
    ///   - wishlistName: Nama item/barang impian yang ingin dicapai.
    ///   - petType: Spesies/ras hewan peliharaan hasil tetasan telur (e.g., "Cat", "Dog").
    func completeOnboarding(
        initialSavings: Double,
        targetAmount: Double,
        eggType: String,
        petName: String,
        wishlistName: String,
        petType: String
    ) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // Validasi batasan kalkulasi rasional finansial
        guard targetAmount > 0, initialSavings < targetAmount else {
            print(
                "Error: Target tidak valid atau tabungan awal sudah melampaui target."
            )
            return
        }

        let newPet = PetModel(
            userId: uid,
            name: petName,
            type: petType,
            xp: 0,
            level: 1,
            mood: "hungry"
        )

        let initialGoal = GoalModel(
            userId: uid,
            itemName: wishlistName,
            targetAmount: targetAmount,
            currentAmount: initialSavings,
            isCompleted: false
        )

        do {
            // 1. Menyimpan skema koleksi dasar peliharaan dan target ke Firestore
            try db.collection("pets").addDocument(from: newPet)
            try db.collection("goals").addDocument(from: initialGoal)

            // 2. Mencatat mutasi riwayat jika nominal tabungan awal bernilai positif (> 0)
            if initialSavings > 0 {
                let initialTx = TransactionModel(
                    userId: uid,
                    amount: initialSavings,
                    date: Date(),
                    type: .deposit
                )
                try db.collection("transactions").addDocument(from: initialTx)
            }

            // 3. Mengubah flag status kelulusan onboarding profil pada master record pengguna
            try await db.collection("users").document(uid).updateData([
                "isOnboarded": true,
                "totalSavings": initialSavings,
            ])

        } catch {
            print("Onboarding error: \(error.localizedDescription)")
        }
    }
}
