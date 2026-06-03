//
//  OnboardingScreen.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

/// Model data internal untuk mendefinisikan struktur pilihan opsi telur pada visual antarmuka.
struct EggOption {
    /// ID unik untuk penanda variasi telur.
    let id: String
    /// Nama tampilan dari variasi telur.
    let name: String
    /// Nama berkas gambar yang tersimpan di Xcode Asset Catalog.
    let assetName: String
}

/// Tampilan antarmuka pemandu bagi pengguna baru untuk mengisi target keuangan pertama dan memilih telur peliharaan.
struct OnboardingView: View {
    /// Instance ViewModel lokal penanggung jawab business logic onboarding.
    @StateObject private var onboardingVM = OnboardingViewModel()
    /// Shared ViewModel autentikasi untuk memantau status sesi akun saat ini.
    @EnvironmentObject var authVM: AuthViewModel

    /// State lokal penyimpan teks input nama peliharaan virtual.
    @State private var petNameInput: String = ""

    /// Binding jumlah tabungan awal dalam format string tekstual dari parent view.
    @Binding var rawAmount: String
    /// Binding ID telur terpilih dari parent view.
    @Binding var selectedEgg: String
    /// Binding nama target wishlist barang impian dari parent view.
    @Binding var wishlistName: String
    /// Binding jumlah nominal batas target wishlist dari parent view.
    @Binding var targetAmountString: String

    /// Callback closure yang dipicu setelah form disubmit untuk berpindah ke layar transisi menetas.
    var onStart: () -> Void

    /// Daftar pilihan variasi produk telur awal yang dapat diadopsi pengguna.
    let eggs: [EggOption] = [
        EggOption(id: "rose", name: "Rosie", assetName: "PinkEgg01"),
        EggOption(id: "mint", name: "Sprout", assetName: "GreenEgg01"),
        EggOption(id: "sky", name: "Bloo", assetName: "BlueEgg01"),
        EggOption(id: "sun", name: "Sunny", assetName: "YellowEgg01"),
        EggOption(id: "lilac", name: "Vio", assetName: "PurpleEgg01"),
        EggOption(id: "peach", name: "Pip", assetName: "PeachEgg01"),
    ]

    /// Kumpulan variasi ras hewan peliharaan virtual yang digunakan untuk logika penentuan acak (Gacha).
    private let availablePets = ["Cat", "Dog", "Owl", "Pig", "Raccoon", "Seal"]

    /// Batas nominal input keuangan maksimal sebesar Rp 100 Juta demi keamanan tipe data angka.
    private let maxSavingsLimit: Double = 100_000_000

    /// Formatter angka statis pembentuk format tampilan titik ribuan desimal secara real-time.
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter
    }()

    /// Properti komputasi validasi form untuk mengontrol status keaktifan tombol submit.
    private var isFormValid: Bool {
        let cleanSavings = cleanNumericString(rawAmount)
        let cleanTarget = cleanNumericString(targetAmountString)

        guard let savings = Double(cleanSavings),
            let target = Double(cleanTarget)
        else { return false }

        return !petNameInput.trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
            && !wishlistName.trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
            && savings >= 0 && target > 0 && target <= maxSavingsLimit
            && target >= savings && !selectedEgg.isEmpty
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Welcome to PennyPals!")
                        .font(.title.bold())
                        .foregroundColor(.pennyText)
                    Text("Let's setup your first savings buddy")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)

                // KATEGORI 1: Pemilihan Karakter Peliharaan
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "1. CHOOSE YOUR PET BUDDY")

                    MinimalTextField(
                        icon: "heart.fill",
                        placeholder: "Give your pet a name...",
                        text: $petNameInput
                    )

                    Text("Select an Egg to Hatch:")
                        .font(.footnote.weight(.medium))
                        .foregroundColor(.pennyText)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(eggs, id: \.id) { egg in
                                VStack {
                                    Image(egg.assetName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 70)
                                        .padding(8)
                                        .background(
                                            selectedEgg == egg.id
                                                ? Color.pennyPurple.opacity(
                                                    0.15
                                                ) : Color.clear
                                        )
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 16)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    selectedEgg == egg.id
                                                        ? Color.pennyPurple
                                                        : Color.gray.opacity(
                                                            0.3
                                                        ),
                                                    lineWidth: 2
                                                )
                                        )
                                    Text(egg.name)
                                        .font(.caption.weight(.semibold))
                                        .foregroundColor(.pennyText)
                                }
                                .onTapGesture {
                                    selectedEgg = egg.id
                                }
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
                .padding()
                .background(
                    Color(UIColor.secondarySystemBackground),
                    in: RoundedRectangle(cornerRadius: 20)
                )

                // KATEGORI 2: Penentuan Target Finansial (Wishlist)
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "2. SET YOUR FINANCIAL GOAL")

                    MinimalTextField(
                        icon: "bag.fill",
                        placeholder: "What are you saving for? (e.g., Shoes)",
                        text: $wishlistName
                    )

                    MinimalTextField(
                        icon: "dollarsign.circle.fill",
                        placeholder: "Target Amount (Rp)",
                        text: $targetAmountString,
                        isNumeric: true
                    )
                    .onChange(of: targetAmountString) { newValue in
                        targetAmountString = formatDynamicCurrency(newValue)
                    }

                    MinimalTextField(
                        icon: "archivebox.fill",
                        placeholder: "Initial Savings (Rp) - Optional",
                        text: $rawAmount,
                        isNumeric: true
                    )
                    .onChange(of: rawAmount) { newValue in
                        rawAmount = formatDynamicCurrency(newValue)
                    }

                    HintText(
                        icon: "info.circle",
                        text:
                            "Your pet will grow and evolve as you add savings toward this goal!"
                    )
                }
                .padding()
                .background(
                    Color(UIColor.secondarySystemBackground),
                    in: RoundedRectangle(cornerRadius: 20)
                )

                // Tombol Aksi Penyelesaian Onboarding & Picu Gacha Pet
                Button(action: {
                    let cleanSavings =
                        Double(cleanNumericString(rawAmount)) ?? 0.0
                    let cleanTarget =
                        Double(cleanNumericString(targetAmountString)) ?? 0.0
                    let randomPetType = availablePets.randomElement() ?? "Cat"  // Logika Gacha Hewan Virtual

                    Task {
                        await onboardingVM.completeOnboarding(
                            initialSavings: cleanSavings,
                            targetAmount: cleanTarget,
                            eggType: selectedEgg,
                            petName: petNameInput,
                            wishlistName: wishlistName,
                            petType: randomPetType
                        )
                        onStart()  // Mematangkan pemicu transisi menuju layar HatchingView
                    }
                }) {
                    Text("Hatch My Egg!")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            isFormValid ? Color.pennyPurple : Color.gray
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(!isFormValid)
                .padding(.top, 8)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.pennyBackground.ignoresSafeArea())
    }

    // --- HELPER LOGIC FUNCTIONS ---

    /// Memformat teks input angka menjadi format string decimal berpemisah titik secara real-time.
    private func formatDynamicCurrency(_ input: String) -> String {
        let digits = cleanNumericString(input)
        if digits.isEmpty { return "" }
        guard let doubleValue = Double(digits) else { return "" }
        let finalValue = min(doubleValue, maxSavingsLimit)

        return Self.currencyFormatter.string(from: NSNumber(value: finalValue))
            ?? ""
    }

    /// Menyaring teks dengan membuang seluruh karakter non-angka.
    private func cleanNumericString(_ input: String) -> String {
        return input.filter { $0.isNumber }
    }
}

// MARK: - REUSABLE UI COMPONENTS

/// Label penanda kecil di atas kelompok baris input formulir.
struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.caption.weight(.bold))
            .foregroundColor(.gray)
            .kerning(1.2)
    }
}

/// Komponen teks petunjuk pembantu navigasi di bawah isian form.
struct HintText: View {
    let icon: String
    let text: String
    var isWarning: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption2)
        .foregroundColor(isWarning ? .red : .gray)
    }
}

/// Baris input tekstual minimalis kustom terstandarisasi untuk keselarasan tema aplikasi.
struct MinimalTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isNumeric: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)

            TextField(placeholder, text: $text)
                .font(.body.weight(.medium))
                .foregroundColor(.pennyText)
                .keyboardType(isNumeric ? .numberPad : .default)
                .autocorrectionDisabled()
        }
        .padding()
        .background(
            Color(UIColor.systemBackground),
            in: RoundedRectangle(cornerRadius: 12)
        )
    }
}
