//
//  OnboardingView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

/// Antarmuka formulir pengenalan (Onboarding) bagi pengguna baru untuk mempersiapkan data peliharaan, target tabungan, dan telur pilihan mereka.
/// View ini hanya bertanggung jawab atas tampilan UI — seluruh state, validasi, dan logika bisnis dikelola oleh OnboardingViewModel.
struct OnboardingView: View {

    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @EnvironmentObject var authVM: AuthViewModel

    /// Closure yang memicu transisi keluar dari alur onboarding (misalnya beralih ke layar Hatching atau Home).
    var onStart: () -> Void

    var body: some View {
        VStack(spacing: 0) {

            // Bagian Tombol Log Out (Bar Atas)
            HStack {
                Spacer()
                Button(action: { authVM.logout() }) {
                    Text("Log Out")
                        .font(.footnote.weight(.medium))
                        .foregroundColor(.red.opacity(0.8))
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }

            // Bagian Judul Header
            VStack(alignment: .leading, spacing: 4) {
                Text("Let's set you up")
                    .font(.largeTitle.bold())
                    .foregroundColor(.pennyText)
                Text("A few quick steps to hatch your pal")
                    .font(.body)
                    .foregroundColor(.pennySecondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {

                    // Seksi Tabungan Awal
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "INITIAL SAVINGS")

                        HStack(alignment: .bottom, spacing: 8) {
                            Text("Rp")
                                .font(.title3.bold())
                                .foregroundColor(.pennySecondaryText)
                                .padding(.bottom, 4)

                            TextField("0", text: $onboardingVM.rawAmount)
                                .keyboardType(.numberPad)
                                .font(
                                    .system(
                                        size: 32,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                .foregroundColor(.pennyText)
                                .onChange(of: onboardingVM.rawAmount) { _, newValue in
                                    onboardingVM.rawAmount = onboardingVM.formatCurrencyInput(newValue)
                                }
                        }

                        Divider()

                        if onboardingVM.isInitialAmountOverLimit {
                            HintText(
                                icon: "exclamationmark.triangle.fill",
                                text:
                                    "Batas maksimal tabungan awal adalah Rp 100.000.000",
                                isWarning: true
                            )
                        }

                        // Preset Tabungan Awal Cepat
                        HStack(spacing: 8) {
                            ForEach(
                                ["100000", "500000", "1000000", "5000000"],
                                id: \.self
                            ) { amount in
                                let formattedPreset = onboardingVM.formatCurrencyInput(amount)
                                let isSelected =
                                    onboardingVM.cleanNumericString(onboardingVM.rawAmount) == amount

                                Button(action: {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        onboardingVM.rawAmount = formattedPreset
                                    }
                                }) {
                                    Text(formattedPreset)
                                        .font(.caption.weight(.medium))
                                        .frame(
                                            maxWidth: .infinity,
                                            minHeight: 36
                                        )
                                        .background(
                                            isSelected
                                                ? Color.pennyPurple
                                                : Color.gray.opacity(0.1)
                                        )
                                        .foregroundColor(
                                            isSelected ? .white : .pennyText
                                        )
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.top, 4)
                    }

                    // Seksi Target Tabungan dan Nominal
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: "YOUR FIRST WISHLIST GOAL")

                        VStack(spacing: 0) {
                            MinimalTextField(
                                icon: "bag",
                                placeholder: "Nama barang (Contoh: Laptop)",
                                text: $onboardingVM.wishlistName
                            )
                            Divider().padding(.leading, 32)
                            MinimalTextField(
                                icon: "tag",
                                placeholder: "Target harga nominal (Rp)",
                                text: $onboardingVM.targetAmountString,
                                isNumeric: true
                            )
                            .onChange(of: onboardingVM.targetAmountString) { _, newValue in
                                onboardingVM.targetAmountString = onboardingVM.formatCurrencyInput(newValue)
                            }
                        }
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)

                        if onboardingVM.isInitialExceedsTarget {
                            HintText(
                                icon: "exclamationmark.triangle.fill",
                                text:
                                    "Tabungan awal tidak boleh melebihi harga target barang!",
                                isWarning: true
                            )
                        }
                    }

                    // Seksi Nama Peliharaan
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "YOUR PET NAME")

                        MinimalTextField(
                            icon: "pawprint",
                            placeholder: "Nama pet kamu (Contoh: Mochi)",
                            text: $onboardingVM.petNameInput
                        )
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                    }

                    // Seksi Pilihan Varian Telur
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: "CHOOSE YOUR EGG")

                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: 90), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(onboardingVM.eggs, id: \.id) { egg in
                                let isSelected = onboardingVM.selectedEgg == egg.id

                                Button(action: {
                                    withAnimation(
                                        .spring(
                                            response: 0.3,
                                            dampingFraction: 0.6
                                        )
                                    ) {
                                        onboardingVM.selectedEgg = egg.id
                                    }
                                }) {
                                    VStack(spacing: 8) {
                                        Image(egg.assetName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .scaleEffect(isSelected ? 1.1 : 1.0)
                                            .opacity(
                                                onboardingVM.selectedEgg.isEmpty
                                                    || isSelected ? 1.0 : 0.5
                                            )

                                        Text(egg.name)
                                            .font(
                                                .caption.weight(
                                                    isSelected
                                                        ? .bold : .regular
                                                )
                                            )
                                            .foregroundColor(
                                                isSelected
                                                    ? .pennyPurple
                                                    : .pennySecondaryText
                                            )
                                    }
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        isSelected
                                            ? Color.pennyPurple.opacity(0.1)
                                            : Color.clear
                                    )
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                isSelected
                                                    ? Color.pennyPurple
                                                    : Color.gray.opacity(0.2),
                                                lineWidth: isSelected ? 2 : 1
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }

            // Tombol Mulai (Submit)
            Button(action: {
                Task {
                    await onboardingVM.completeOnboarding()
                    onStart()
                }
            }) {
                Text("Start Saving →")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PennyPrimaryButtonStyle())
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .padding(.top, 8)
            .disabled(!onboardingVM.isFormValid)
            .opacity(onboardingVM.isFormValid ? 1.0 : 0.5)
        }
        .background(Color.pennyBackground.ignoresSafeArea())
    }
}

// MARK: - UI Components Bawaan

/// Komponen untuk memisahkan grup antar kategori formulir dengan gaya teks *capitalized*.
struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.caption.weight(.bold))
            .foregroundColor(.gray)
            .kerning(1.2)
    }
}

/// Komponen teks bantuan kecil untuk memandu pengguna atau memberikan pesan *error* validasi ringan.
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

/// Komponen input teks kustom tanpa garis kotak luar untuk desain *clean UI*.
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
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
