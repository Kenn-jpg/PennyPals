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

    // MARK: - Properties (State Form Onboarding)

    /// Input nominal tabungan awal yang diketik pengguna (sudah diformat dengan titik ribuan).
    @Published var rawAmount: String = ""

    /// ID telur yang dipilih pengguna (contoh: "rose", "mint", "sky").
    @Published var selectedEgg: String = "rose"

    /// Nama item wishlist yang ingin ditargetkan pengguna.
    @Published var wishlistName: String = ""

    /// Input nominal target tabungan wishlist (sudah diformat dengan titik ribuan).
    @Published var targetAmountString: String = ""

    /// Nama kustom yang diberikan pengguna untuk peliharaannya.
    @Published var petNameInput: String = ""

    private var db = Firestore.firestore()

    // MARK: - Data Statis (Pilihan Telur & Ras Hewan)

    /// Daftar pilihan telur kosmetik yang tersedia saat onboarding.
    let eggs: [EggOption] = [
        EggOption(id: "rose", name: "Rosie", assetName: "PinkEgg01"),
        EggOption(id: "mint", name: "Sprout", assetName: "GreenEgg01"),
        EggOption(id: "sky", name: "Bloo", assetName: "BlueEgg01"),
        EggOption(id: "sun", name: "Sunny", assetName: "YellowEgg01"),
        EggOption(id: "lilac", name: "Vio", assetName: "PurpleEgg01"),
        EggOption(id: "peach", name: "Pip", assetName: "PeachEgg01"),
    ]

    /// Kumpulan ras hewan yang akan didapat secara acak (gacha) ketika telur menetas.
    private let availablePets = ["Cat", "Dog", "Owl", "Pig", "Raccoon", "Seal"]

    /// Batas limit maksimum tabungan untuk mencegah input yang tidak wajar.
    let maxSavingsLimit: Double = 100_000_000

    /// Formatter angka untuk memisahkan nominal ribuan dengan titik.
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter
    }()

    // MARK: - Validasi Form (Computed Property)

    /// Status validasi kelengkapan seluruh form onboarding.
    /// Mengatur apakah tombol "Start Saving" bisa ditekan atau tidak.
    var isFormValid: Bool {
        let initialAmount = Double(cleanNumericString(rawAmount)) ?? 0
        let targetAmount = Double(cleanNumericString(targetAmountString)) ?? 0

        guard initialAmount >= 0, initialAmount <= maxSavingsLimit,
            targetAmount > 0, targetAmount <= maxSavingsLimit,
            initialAmount < targetAmount
        else { return false }

        return !selectedEgg.isEmpty
            && !wishlistName.trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
            && !petNameInput.trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
    }

    /// Menandakan apakah tabungan awal sudah menyentuh batas limit maksimum.
    var isInitialAmountOverLimit: Bool {
        let currentAmount = Double(cleanNumericString(rawAmount)) ?? 0
        return currentAmount >= maxSavingsLimit
    }

    /// Menandakan apakah tabungan awal melebihi target wishlist (tidak valid).
    var isInitialExceedsTarget: Bool {
        let currentInitial = Double(cleanNumericString(rawAmount)) ?? 0
        let currentTarget = Double(cleanNumericString(targetAmountString)) ?? 0
        return currentTarget > 0 && currentInitial >= currentTarget
    }

    // MARK: - Format & Parsing Helper

    /// Memformat string raw angka agar dipisah dengan titik ribuan secara real-time.
    /// - Parameter input: String mentah dari keyboard pengguna.
    /// - Returns: String yang sudah terformat (contoh: "1.500.000").
    func formatCurrencyInput(_ input: String) -> String {
        let digits = cleanNumericString(input)
        guard let doubleValue = Double(digits) else { return "" }
        let finalValue = min(doubleValue, maxSavingsLimit)

        return Self.currencyFormatter.string(from: NSNumber(value: finalValue))
            ?? ""
    }

    /// Menghilangkan karakter non-angka (seperti pemisah ribuan) agar string bisa dikonversi menjadi Double.
    /// - Parameter input: String yang mungkin mengandung titik separator.
    /// - Returns: String murni berisi angka saja.
    func cleanNumericString(_ input: String) -> String {
        return input.filter { $0.isNumber }
    }

    // MARK: - Reset State

    /// Mengembalikan semua input form ke kondisi awal (digunakan saat user baru login).
    func resetForm() {
        rawAmount = ""
        selectedEgg = "rose"
        wishlistName = ""
        targetAmountString = ""
        petNameInput = ""
    }

    // MARK: - Submit Onboarding (Simpan ke Firestore)

    /// Menyelesaikan proses onboarding dengan melakukan batch commit/instansiasi data relasional awal pengguna baru secara paralel ke Firestore.
    /// Ras hewan ditentukan secara acak (gacha) di dalam ViewModel ini.
    func completeOnboarding() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let initialSavings = Double(cleanNumericString(rawAmount)) ?? 0
        let targetAmount = Double(cleanNumericString(targetAmountString)) ?? 0
        let petName = petNameInput.trimmingCharacters(in: .whitespacesAndNewlines)

        // Validasi batasan kalkulasi rasional finansial
        guard targetAmount > 0, initialSavings < targetAmount else {
            print(
                "Error: Target tidak valid atau tabungan awal sudah melampaui target."
            )
            return
        }

        // Mengundi ras pet dari daftar availablePets (gacha) secara acak
        let randomlyHatchedPet = availablePets.randomElement() ?? "Cat"

        let newPet = PetModel(
            userId: uid,
            name: petName,
            type: randomlyHatchedPet,
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
