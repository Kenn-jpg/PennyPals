//
//  HomeScreen.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()
    @EnvironmentObject var authVM: AuthViewModel

    @State private var isBouncing = false
    @State private var showSavingsModal = false
    @State private var showNewGoalModal = false  // State baru untuk trigger modal Wishlist

    // --- Penalty Status Logic ---
    private enum PenaltyStatus {
        case safe
        case warning
        case danger
    }

    private var penaltyStatus: PenaltyStatus {
        guard let user = authVM.currentUser else { return .safe }

        // Jika sudah kena penalti
        if !user.isSafeFromPenalty {
            return .danger
        }

        // Hitung sisa waktu sebelum penalty check
        let now = Date()
        let hoursRemaining = Calendar.current.dateComponents(
            [.hour], from: now, to: user.nextPenaltyCheck
        ).hour ?? 0

        // Warning jika sisa waktu <= 24 jam
        if hoursRemaining <= 24 {
            return .warning
        }

        return .safe
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Header Profil & Stats
                HStack {
                    HStack {
                        Circle().fill(
                            LinearGradient(
                                colors: [Color(hex: "#FF8FB5"), .pennyPurple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ).frame(width: 44, height: 44).overlay(
                            Text(
                                String(
                                    authVM.currentUser?.username.prefix(2)
                                        ?? "JM"
                                ).uppercased()
                            ).font(.headline).foregroundColor(.white)
                        )
                        VStack(alignment: .leading) {
                            Text("Welcome back").font(.caption).foregroundColor(
                                .pennySecondaryText
                            )
                            Text(authVM.currentUser?.username ?? "Loading...")
                                .font(.headline).foregroundColor(.pennyText)
                        }
                    }
                    Spacer()
                    HStack {
                        Label(
                            "Lv \(homeVM.pet?.level ?? 0)",
                            systemImage: "sparkles"
                        ).font(.footnote.weight(.semibold)).padding(
                            .horizontal,
                            10
                        ).padding(.vertical, 6).background(
                            .thinMaterial,
                            in: Capsule()
                        ).foregroundColor(.pennyText)

                        Label(
                            "\(authVM.currentUser?.coins ?? 0)",
                            systemImage: "bitcoinsign.circle.fill"
                        ).font(.footnote.weight(.semibold)).padding(
                            .horizontal,
                            10
                        ).padding(.vertical, 6).background(
                            .thinMaterial,
                            in: Capsule()
                        ).foregroundColor(.pennyText)
                    }
                }.padding(.horizontal)

                Spacer(minLength: 0)

                // Main Pet Area
                VStack(spacing: 12) {
                    Text(
                        homeVM.pet?.mood == "happy"
                            ? "Yay! Thanks for saving! 🍓"
                            : (homeVM.pet?.mood == "sad"
                                ? "I missed you... T_T"
                                : "I'm hungry — let's save! 🍓")
                    )
                    .font(.subheadline.weight(.medium)).foregroundColor(
                        .pennyText
                    ).padding().background(
                        Color(UIColor.systemBackground),
                        in: RoundedRectangle(cornerRadius: 16)
                    ).shadow(color: .black.opacity(0.05), radius: 5, y: 2)

                    ZStack(alignment: .topTrailing) {
                        Circle().fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#FFE8F1"),
                                    Color(hex: "#E8DCFF"),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ).frame(width: 200, height: 200)
                                
                        PetView(mood: homeVM.pet?.mood ?? "hungry", size: 180)
                            .offset(y: isBouncing ? -8 : 8)
                            .onAppear {
                                withAnimation(
                                    .easeInOut(duration: 1.5).repeatForever(
                                        autoreverses: true
                                    )
                                ) {
                                    isBouncing = true
                                }
                            }

                        Label(
                            "\(authVM.currentUser?.streak ?? 0)d streak",
                            systemImage: "flame.fill"
                        ).font(.caption.weight(.bold)).foregroundColor(
                            Color(hex: "#7A4A2A")
                        ).padding(.horizontal, 10).padding(.vertical, 6)
                            .background(Color(hex: "#FFEDC4"), in: Capsule())
                            .offset(x: 20, y: 10)
                    }
                }

                Spacer(minLength: 0)

                // Dashboard Cards Area
                VStack(spacing: 16) {
                    // Total Savings
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Label(
                                "Total Savings",
                                systemImage: "wallet.pass.fill"
                            )
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.pennySecondaryText)
                            Spacer()
                        }

                        // Langsung panggil totalSavings karena sudah bertipe Int
                        let total = authVM.currentUser?.totalSavings ?? 0
                        Text("Rp \(total.formattedWithSeparator)")
                            .font(.title2.bold())
                            .foregroundColor(.pennyText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        Color(UIColor.systemBackground),
                        in: RoundedRectangle(cornerRadius: 20)
                    )

                    // XP Card
                    VStack(spacing: 8) {
                        HStack {
                            Text("\(homeVM.pet?.name ?? "Pet") XP").font(
                                .subheadline.weight(.medium)
                            ).foregroundColor(.pennySecondaryText)
                            Spacer()
                            Text(
                                "\(homeVM.pet?.xp ?? 0) / \(homeVM.pet?.maxXP ?? 200)"
                            ).font(.subheadline.bold()).foregroundColor(
                                .pennyPurple
                            )
                        }
                        ProgressView(
                            value: Double(homeVM.pet?.xp ?? 0),
                            total: Double(homeVM.pet?.maxXP ?? 200)
                        ).tint(.pennyPurple)
                    }.padding().background(
                        Color(UIColor.systemBackground),
                        in: RoundedRectangle(cornerRadius: 20)
                    )

                    // Fix: FixedSize menjaga HStack sejajar, frame max tinggi dipasang ke setiap VStack
                    HStack(spacing: 16) {
                        // Penalty Card (3-state: Safe / Warning / Danger)
                        VStack(alignment: .leading, spacing: 8) {
                            Label(
                                "Penalty",
                                systemImage: penaltyStatus == .safe
                                    ? "checkmark.shield.fill"
                                    : (penaltyStatus == .warning
                                        ? "exclamationmark.triangle.fill"
                                        : "xmark.shield.fill")
                            )
                            .font(.caption.weight(.medium))
                            .foregroundColor(
                                penaltyStatus == .safe
                                    ? .green
                                    : (penaltyStatus == .warning
                                        ? .orange : .red)
                            )

                            Spacer()  // Mendorong konten ke atas dan bawah

                            Text(
                                penaltyStatus == .safe
                                    ? "Safe ✓"
                                    : (penaltyStatus == .warning
                                        ? "Warning ⚠️" : "Danger!")
                            )
                            .font(.headline)
                            .foregroundColor(
                                penaltyStatus == .danger ? .red : .pennyText
                            )

                            Text(
                                penaltyStatus == .safe
                                    ? "You're on track!"
                                    : (penaltyStatus == .warning
                                        ? "Save soon to stay safe"
                                        : "Streak lost, XP reduced")
                            )
                            .font(.caption2)
                            .foregroundColor(
                                penaltyStatus == .warning
                                    ? .orange.opacity(0.8)
                                    : .pennySecondaryText
                            )
                        }
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .topLeading
                        )
                        .padding()
                        .background(
                            penaltyStatus == .warning
                                ? Color(hex: "#FFF8EC")
                                : (penaltyStatus == .danger
                                    ? Color(hex: "#FFF0F0")
                                    : Color(UIColor.systemBackground)),
                            in: RoundedRectangle(cornerRadius: 20)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    penaltyStatus == .warning
                                        ? Color.orange.opacity(0.3)
                                        : (penaltyStatus == .danger
                                            ? Color.red.opacity(0.3)
                                            : Color.clear),
                                    lineWidth: 1.5
                                )
                        )

                        // Wishlist Card
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Wishlist", systemImage: "target").font(
                                .caption.weight(.medium)
                            ).foregroundColor(.pennyPurple)

                            let currentAmt = homeVM.goal?.currentAmount ?? 0
                            let targetAmt = homeVM.goal?.targetAmount ?? 1
                            let isGoalCompleted =
                                currentAmt >= targetAmt && targetAmt > 0

                            Spacer()

                            HStack {
                                Text(homeVM.goal?.itemName ?? "No Goal").font(
                                    .subheadline.weight(.semibold)
                                ).lineLimit(1)
                                Spacer()
                                if isGoalCompleted {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.green)
                                        .font(.subheadline)
                                }
                            }

                            // Logika Tampilan Jika Goal Selesai
                            if isGoalCompleted {
                                Button(action: {
                                    showNewGoalModal = true
                                }) {
                                    Text("Set New Goal")
                                        .font(.caption2.weight(.bold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 6)
                                        .background(Color.green, in: Capsule())
                                }
                            } else {
                                ProgressView(
                                    value: currentAmt,
                                    total: targetAmt
                                ).tint(.blue)

                                Text(
                                    "\(Int(currentAmt/1000))k / \(Int(targetAmt/1000))k"
                                ).font(.caption2).foregroundColor(
                                    .pennySecondaryText
                                )
                            }
                        }
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .topLeading
                        )
                        .padding()
                        .background(
                            Color(UIColor.systemBackground),
                            in: RoundedRectangle(cornerRadius: 20)
                        )
                    }
                    .fixedSize(horizontal: false, vertical: true)  // Kunci perbaikan tinggi di sini

                    Button(action: { showSavingsModal = true }) {
                        Label("Manual Input", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }.buttonStyle(PennyPrimaryButtonStyle())
                }.padding(.horizontal)

                Spacer(minLength: 0)
            }
            .padding(.vertical).frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pennyBackground.ignoresSafeArea())
            .onAppear { homeVM.checkDailyPenalty() }
            .sheet(isPresented: $showSavingsModal) {
                AddSavingsModal(onSave: { amount in
                    if let currentUser = authVM.currentUser {
                        homeVM.addSavings(
                            amount: amount,
                            currentUser: currentUser
                        )
                    }
                })
            }
            // Sheet untuk New Goal Modal
            .sheet(isPresented: $showNewGoalModal) {
                SetNewGoalModal(
                    completedGoalName: homeVM.goal?.itemName ?? "Goal",
                    onSave: { itemName, targetAmount in
                        homeVM.setNewGoal(
                            itemName: itemName,
                            targetAmount: targetAmount
                        )
                    }
                )
            }
        }
    }
}

extension Int {
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
