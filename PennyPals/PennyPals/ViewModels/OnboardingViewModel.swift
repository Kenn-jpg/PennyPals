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

/// ViewModel yang bertanggung jawab atas business logic pendaftaran data awal pengguna (Onboarding).
/// Menangani inisialisasi peliharaan baru, pembuatan target keuangan awal, pencatatan transaksi perdana,
/// serta memperbarui status onboarding pengguna di Firebase Firestore.
@MainActor
class OnboardingViewModel: ObservableObject {
    /// Referensi instance database Firestore untuk operasi tulis data.
    private var db = Firestore.firestore()

    /// Menyelesaikan proses onboarding dengan mendaftarkan semua entitas awal ke Firestore secara asinkronus.
    /// - Parameters:
    ///   - initialSavings: Jumlah nominal uang yang sudah dimiliki/ditabung di awal oleh pengguna.
    ///   - targetAmount: Nominal uang target pencapaian untuk barang impian (Wishlist).
    ///   - eggType: ID tipe telur yang dipilih oleh pengguna (contoh: "rose", "mint", "sky").
    ///   - petName: Nama panggilan yang diberikan pengguna untuk peliharaannya.
    ///   - wishlistName: Nama barang impian yang ingin dicapai pengguna.
    ///   - petType: Jenis hewan peliharaan hasil acak/gacha dari telur (contoh: "Cat", "Dog", "Owl").
    func completeOnboarding(
        initialSavings: Double,
        targetAmount: Double,
        eggType: String,
        petName: String,
        wishlistName: String,
        petType: String  // Parameter jenis pet hasil gacha acak
    ) async {
        // Memastikan pengguna sudah terautentikasi dan memiliki UID yang valid dari FirebaseAuth
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // 1. Membuat objek model peliharaan baru dengan level awal 1 dan mood lapar
        let newPet = PetModel(
            userId: uid,
            name: petName,
            type: petType,  // Menyimpan jenis hewan riil hasil gacha ke database
            xp: 0,
            level: 1,
            mood: "hungry"
        )

        // 2. Membuat objek target finansial pertama (Wishlist) milik pengguna
        let initialGoal = GoalModel(
            userId: uid,
            itemName: wishlistName,
            targetAmount: targetAmount,
            currentAmount: initialSavings,  // Progress awal langsung diisi dari tabungan awal
            isCompleted: false
        )

        do {
            // A. Menyimpan data peliharaan ke koleksi "pets" di Firestore
            try db.collection("pets").addDocument(from: newPet)

            // B. Menyimpan data target awal ke koleksi "goals" di Firestore
            try db.collection("goals").addDocument(from: initialGoal)

            // C. Jika pengguna memasukkan tabungan awal > 0, catat sebagai transaksi deposit pertama
            if initialSavings > 0 {
                let initialTx = TransactionModel(
                    userId: uid,
                    amount: initialSavings,
                    date: Date(),
                    type: .deposit
                )
                try db.collection("transactions").addDocument(from: initialTx)
            }

            // D. Memperbarui status akun pengguna di koleksi "users" agar flag onboarding disetel selesai
            try await db.collection("users").document(uid).updateData([
                "isOnboarded": true,
                "totalSavings": initialSavings,
            ])

        } catch {
            // Menangkap dan mencetak log kesalahan jika proses penulisan Firestore gagal
            print("Onboarding error: \(error.localizedDescription)")
        }
    }
}
