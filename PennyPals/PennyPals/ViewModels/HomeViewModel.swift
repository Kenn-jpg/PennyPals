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
    // Deklarasi properti yang akan dipantau oleh antarmuka (SwiftUI).
    // Ketika nilai ini berubah, tampilan aplikasi akan otomatis diperbarui.
    @Published var pet: PetModel?
    @Published var goal: GoalModel?

    // Menyiapkan referensi ke database Firestore untuk mengambil dan menyimpan data.
    private var db = Firestore.firestore()

    // Mengambil ID unik (UID) dari pengguna yang saat ini sedang login melalui Firebase Auth.
    private var userId: String? { Auth.auth().currentUser?.uid }

    init() {
        // Memanggil fungsi untuk mulai menarik data dari Firestore saat ViewModel ini pertama kali dibuat.
        fetchPetData()
        fetchGoalData()
    }

    func fetchPetData() {
        guard let uid = userId else { return }

        // Menggunakan addSnapshotListener agar aplikasi terus mendengarkan perubahan data peliharaan secara real-time.
        db.collection("pets").whereField("userId", isEqualTo: uid)
            .addSnapshotListener { querySnapshot, error in
                // Memastikan pembaruan properti UI selalu dijalankan di Main Thread.
                Task { @MainActor in
                    guard let documents = querySnapshot?.documents,
                        !documents.isEmpty
                    else { return }

                    // Mengubah data mentah Firestore menjadi bentuk objek PetModel.
                    self.pet = try? documents.first?.data(as: PetModel.self)
                }
            }
    }

    func fetchGoalData() {
        guard let uid = userId else { return }

        // Memantau data target tabungan (goal) pengguna secara real-time dari Firestore.
        db.collection("goals").whereField("userId", isEqualTo: uid).limit(to: 1)
            .addSnapshotListener { querySnapshot, error in
                Task { @MainActor in
                    guard let documents = querySnapshot?.documents,
                        !documents.isEmpty
                    else { return }
                    self.goal = try? documents.first?.data(as: GoalModel.self)
                }
            }
    }

    // MARK: - Gamification Logic (Menabung & XP)
    func addSavings(amount: Double) {
        guard let uid = userId, let currentPet = pet, let currentGoal = goal
        else { return }

        // Menambahkan nominal tabungan baru ke total target tabungan saat ini, lalu menyimpannya ke database.
        let newGoalAmount = currentGoal.currentAmount + amount
        db.collection("goals").document(currentGoal.id!).updateData([
            "currentAmount": newGoalAmount
        ])

        // Mengkalkulasi penambahan XP peliharaan (contoh: setiap Rp 1.000 bernilai 1 XP).
        let gainedXP = Int(amount / 1000)
        var newXP = currentPet.xp + gainedXP
        var newLevel = currentPet.level
        let newMood = "happy"

        // Mengecek apakah XP yang baru melebihi batas maksimal untuk naik level.
        if newXP >= currentPet.maxXP {
            newLevel += 1
            newXP = newXP - currentPet.maxXP

            // Memberikan hadiah koin karena pengguna berhasil menaikkan level peliharaannya.
            rewardCoins(amount: 500)
        }

        // Menyimpan data kemajuan terbaru dari peliharaan (level, XP, dan suasana hati) ke Firestore.
        db.collection("pets").document(currentPet.id!).updateData([
            "xp": newXP,
            "level": newLevel,
            "mood": newMood,
        ])

        // Membuat objek pencatatan transaksi untuk riwayat aplikasi.
        let transaction = TransactionModel(
            userId: uid,
            amount: amount,
            date: Date(),
            type: .deposit
        )

        // Merekam data transaksi ke Firestore. Menggunakan '_ =' karena kita tidak perlu menangkap hasil kembaliannya.
        _ = try? db.collection("transactions").addDocument(from: transaction)
    }

    // MARK: - Penalty Mechanism
    func checkDailyPenalty() {
        guard let uid = userId, let currentPet = pet else { return }

        // Membuka Task baru untuk menggunakan fitur async/await agar penarikan data lebih aman dari sisi multi-threading.
        Task { @MainActor in
            do {
                // Menarik data pengguna menggunakan 'await' (pengganti closure) untuk mengecek batas waktu penalti.
                let snapshot = try await db.collection("users").document(uid)
                    .getDocument()
                let user = try snapshot.data(as: UserModel.self)
                let now = Date()

                // Memeriksa apakah waktu saat ini sudah melewati tenggat waktu kewajiban menabung.
                if now >= user.nextPenaltyCheck {

                    // Menetapkan aturan hukuman pengurangan poin pengalaman (XP).
                    let penaltyXP = 200
                    var newXP = currentPet.xp - penaltyXP
                    var newLevel = currentPet.level
                    let newMood = "sad"

                    // Menghitung kalkulasi penurunan level (demote) jika XP jatuh di bawah nol.
                    if newXP < 0 {
                        if newLevel > 1 {
                            newLevel -= 1
                            let maxXPForNewLevel = newLevel * 1000
                            newXP = maxXPForNewLevel + newXP
                        } else {
                            // Mencegah XP bernilai negatif jika peliharaan sudah berada di level terendah.
                            newXP = 0
                        }
                    }

                    // Menentukan batas waktu penalti berikutnya (diberikan kelonggaran 1 hari dari sekarang).
                    guard
                        let nextCheck = Calendar.current.date(
                            byAdding: .day,
                            value: 1,
                            to: now
                        )
                    else { return }

                    // Menyiapkan operasi 'Batch' untuk memastikan semua perubahan database terjadi bersamaan (atomik).
                    let batch = db.batch()

                    // Memasukkan perintah reset streak dan update status penalti pengguna ke dalam keranjang batch.
                    let userRef = db.collection("users").document(uid)
                    batch.updateData(
                        [
                            "streak": 0,
                            "isSafeFromPenalty": false,
                            "nextPenaltyCheck": nextCheck,
                        ],
                        forDocument: userRef
                    )

                    // Memasukkan perintah update kondisi peliharaan (XP, level, dan mood) ke dalam keranjang batch.
                    if let petId = currentPet.id {
                        let petRef = db.collection("pets").document(petId)
                        batch.updateData(
                            [
                                "xp": newXP,
                                "level": newLevel,
                                "mood": newMood,
                            ],
                            forDocument: petRef
                        )
                    }

                    // Memasukkan pencatatan riwayat hukuman ke dalam keranjang batch.
                    let transactionRef = db.collection("transactions")
                        .document()
                    let penaltyTx = TransactionModel(
                        id: transactionRef.documentID,
                        userId: uid,
                        amount: 0,
                        date: now,
                        type: .penalty
                    )
                    _ = try? batch.setData(
                        from: penaltyTx,
                        forDocument: transactionRef
                    )

                    // Mengeksekusi seluruh antrean keranjang batch secara asinkronus (Solusi dari warning Xcode).
                    try await batch.commit()
                    print(
                        "Penalti harian berhasil diterapkan! Streak direset ke 0."
                    )
                }
            } catch {
                // Menangkap dan mencetak ke konsol jika terjadi kesalahan komunikasi dengan server Firebase.
                print("Gagal memproses penalti: \(error.localizedDescription)")
            }
        }
    }

    private func rewardCoins(amount: Int) {
        guard let uid = userId else { return }

        // Memberikan instruksi ke Firestore untuk menambahkan saldo koin secara spesifik (inkremental).
        db.collection("users").document(uid).updateData([
            "coins": FieldValue.increment(Int64(amount))
        ])
    }
}
