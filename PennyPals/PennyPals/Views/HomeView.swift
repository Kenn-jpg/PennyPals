//
//  HomeView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()
    @EnvironmentObject var authVM: AuthViewModel

    @State private var isBouncing = false

    // 🌟 Menggabungkan state modal menjadi satu karena AddSavingsModal sudah multifungsi
    @State private var showTransactionModal = false
    @State private var showNewGoalModal = false

    // 🌟 PERBAIKAN: State untuk menampung item yang sedang dilengkapi secara real-time
    @State private var shopItems: [ShopItemModel] = []
    @State private var equippedBackgroundId: String? = nil
    @State private var equippedAccessoryId: String? = nil

    private let db = Firestore.firestore()

    // 🌟 PERBAIKAN: Computed property untuk mendapatkan objek item utuh
    private var equippedBackground: ShopItemModel? {
        shopItems.first { $0.id == equippedBackgroundId }
    }

    private var equippedAccessory: ShopItemModel? {
        shopItems.first { $0.id == equippedAccessoryId }
    }

    // --- Penalty Status Logic ---
    private enum PenaltyStatus {
        case safe
        case warning
        case danger
    }

    private var penaltyStatus: PenaltyStatus {
        guard let user = authVM.currentUser else { return .safe }

        if !user.isSafeFromPenalty {
            return .danger
        }

        let now = Date()
        let hoursRemaining =
            Calendar.current.dateComponents(
                [.hour],
                from: now,
                to: user.nextPenaltyCheck
            ).hour ?? 0

        if hoursRemaining <= 24 {
            return .warning
        }

        return .safe
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                headerSection

                Spacer(minLength: 0)

                petSection

                Spacer(minLength: 0)

                dashboardCardsSection

                Spacer(minLength: 0)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pennyBackground.ignoresSafeArea())
            .onAppear {
                // ✅ Memanggil method langsung tanpa menggunakan '$'
                homeVM.checkDailyPenalty()
                if let currentUser = authVM.currentUser {
                    homeVM.checkDailyHunger(currentUser: currentUser)
                }

                // 🌟 PERBAIKAN: Jalankan fungsi fetch & listener saat layar muncul
                startEquipmentListener()
                fetchShopItems()
            }
            .onChange(of: authVM.currentUser) { _, newUser in
                if let user = newUser {
                    homeVM.checkDailyHunger(currentUser: user)
                }
            }
            // 🌟 SATU SHEET UNTUK SEMUA TRANSAKSI (Tabungan & Pengeluaran)
            .sheet(isPresented: $showTransactionModal) {
                // Menangkap 2 value: amount dan isExpense dari Modal
                AddSavingsModal { amount, isExpense in
                    if let currentUser = authVM.currentUser {
                        if isExpense {
                            // Jika toggle Pengeluaran yang dipilih
                            homeVM.addExpense(
                                amount: amount,
                                currentUser: currentUser
                            )
                        } else {
                            // ✅ Memanggil method langsung tanpa menggunakan '$'
                            homeVM.addSavings(
                                amount: amount,
                                currentUser: currentUser
                            )
                        }
                    }
                }
            }
            .sheet(isPresented: $showNewGoalModal) {
                SetNewGoalModal(
                    completedGoalName: homeVM.goal?.itemName ?? "Goal",
                    onSave: { itemName, targetAmount in
                        // ✅ Memanggil method langsung tanpa menggunakan '$'
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

// MARK: - UI Components
extension HomeView {

    private var petMessage: String {
        guard let petMood = homeVM.pet?.mood else {
            return "I'm hungry — let's save! 🍓"
        }

        switch petMood {
        case "happy": return "Yay! Thanks for saving! 🍓"
        case "surprised": return "Whoa! That's a huge saving! 🤩"
        case "wink": return "Looking good! Thanks for the gift! 😉"
        case "sleepy": return "Yawn... I'm so sleepy 😴"
        case "dizzy": return "Whoa, I'm getting dizzy! 😵‍💫"
        case "sad": return "I missed you... T_T"
        case "cry": return "My level dropped... Waaah! 😭"
        case "angry": return "You ignored me! I'm starving! 😡"
        case "hungry": return "I'm hungry — let's save! 🍓"
        default:
            if let user = authVM.currentUser,
                let lastSave = user.lastSavingsDate
            {
                if Calendar.current.isDate(lastSave, inSameDayAs: Date()) {
                    return "Yay! Thanks for saving! 🍓"
                }
            }
            return "I'm hungry — let's save! 🍓"
        }
    }

    private var headerSection: some View {
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
                            authVM.currentUser?.username.prefix(2) ?? "JM"
                        ).uppercased()
                    ).font(.headline).foregroundColor(.white)
                )
                VStack(alignment: .leading) {
                    Text("Welcome back")
                        .font(.caption)
                        .foregroundColor(.pennySecondaryText)
                    Text(authVM.currentUser?.username ?? "Loading...")
                        .font(.headline)
                        .foregroundColor(.pennyText)
                }
            }
            Spacer()
            HStack {
                Label(
                    "Lv \(homeVM.pet?.level ?? 0)",
                    systemImage: "sparkles"
                )
                .font(.footnote.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.thinMaterial, in: Capsule())
                .foregroundColor(.pennyText)

                Label(
                    "\(authVM.currentUser?.coins ?? 0)",
                    systemImage: "bitcoinsign.circle.fill"
                )
                .font(.footnote.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.thinMaterial, in: Capsule())
                .foregroundColor(.pennyText)
            }
        }
        .padding(.horizontal)
    }

    private var petSection: some View {
        VStack(spacing: 12) {
            Text(petMessage)
                .font(.subheadline.weight(.medium))
                .foregroundColor(.pennyText)
                .padding()
                .background(
                    Color(UIColor.systemBackground),
                    in: RoundedRectangle(cornerRadius: 16)
                )
                .shadow(color: .black.opacity(0.05), radius: 5, y: 2)

            ZStack(alignment: .topTrailing) {
                ZStack {
                    // 🌟 PERBAIKAN: RENDER BACKGROUND SECARA DINAMIS (Sama seperti InventoryView)
                    if let bg = equippedBackground {
                        ZStack {
                            if bg.isGradient == true,
                                let endColor = bg.endColorHex
                            {
                                LinearGradient(
                                    colors: [
                                        Color(hex: bg.colorHex ?? "#E8E8E8"),
                                        Color(hex: endColor),
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            } else {
                                Color(hex: bg.colorHex ?? "#E8E8E8")
                            }

                            // Render Bulatan/Spots jika ada
                            if let spotsHex = bg.spotsHex {
                                VStack {
                                    HStack {
                                        Circle()
                                            .fill(Color(hex: spotsHex))
                                            .frame(width: 40)
                                            .offset(x: -10, y: -10)
                                        Spacer()
                                    }
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Circle()
                                            .fill(Color(hex: spotsHex))
                                            .frame(width: 50)
                                            .offset(x: 10, y: 15)
                                    }
                                }
                            }
                        }
                        .frame(width: 200, height: 200)
                        .clipped()  // Mencegah spots keluar lingkaran background
                        .clipShape(Circle())
                        .shadow(
                            color: .black.opacity(0.08),
                            radius: 10,
                            x: 0,
                            y: 4
                        )

                    } else {
                        // Default bulatan putih jika tidak ada background yang dipakai
                        Circle()
                            .fill(Color.white)
                            .frame(width: 200, height: 200)
                            .shadow(
                                color: .black.opacity(0.08),
                                radius: 10,
                                x: 0,
                                y: 4
                            )
                    }

                    // Tampilan Pet Utama
                    PetView(
                        petType: homeVM.pet?.type ?? "Cat",
                        mood: homeVM.pet?.mood ?? "hungry",
                        size: 180
                    )

                    // 🌟 PERBAIKAN: RENDER AKSESORIS DI ATAS PET MENGGUNAKAN SF SYMBOL
                    if let acc = equippedAccessory {
                        Image(systemName: acc.imageName ?? "tshirt.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 85, height: 85)
                            .foregroundColor(.pennyPurple)
                            .offset(y: -25)  // Sesuaikan posisi y agar aksesoris (misal topi/kacamata) pas di badan/kepala pet
                    }
                }
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
                )
                .font(.caption.weight(.bold))
                .foregroundColor(Color(hex: "#7A4A2A"))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(hex: "#FFEDC4"), in: Capsule())
                .offset(x: 10, y: 4)
            }
        }
    }

    private var dashboardCardsSection: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label("Total Savings", systemImage: "wallet.pass.fill")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.pennySecondaryText)
                    Spacer()
                }

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

            VStack(spacing: 8) {
                HStack {
                    Text("\(homeVM.pet?.name ?? "Pet") XP")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.pennySecondaryText)
                    Spacer()
                    Text("\(homeVM.pet?.xp ?? 0) / \(homeVM.pet?.maxXP ?? 200)")
                        .font(.subheadline.bold())
                        .foregroundColor(.pennyPurple)
                }
                ProgressView(
                    value: Double(homeVM.pet?.xp ?? 0),
                    total: Double(homeVM.pet?.maxXP ?? 200)
                )
                .tint(.pennyPurple)
            }
            .padding()
            .background(
                Color(UIColor.systemBackground),
                in: RoundedRectangle(cornerRadius: 20)
            )

            HStack(spacing: 16) {
                penaltyCard
                wishlistCard
            }
            .fixedSize(horizontal: false, vertical: true)

            // 🌟 MENGGABUNGKAN TOMBOL MENJADI SATU KARENA MODAL SUDAH MULTIFUNGSI
            Button(action: {
                showTransactionModal = true
                homeVM.registerModalOpen()
            }) {
                Label("Add Transaction", systemImage: "plus.circle")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(PennyPrimaryButtonStyle())
        }
        .padding(.horizontal)
    }

    private var penaltyCard: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
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
                        : (penaltyStatus == .warning ? .orange : .red)
                )
                Spacer()
            }

            Spacer(minLength: 8)

            VStack(spacing: 6) {
                Text(
                    penaltyStatus == .safe
                        ? "Safe ✓"
                        : (penaltyStatus == .warning ? "Warning ⚠️" : "Danger!")
                )
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(penaltyStatus == .danger ? .red : .pennyText)

                Text(
                    penaltyStatus == .safe
                        ? "You're on track!"
                        : (penaltyStatus == .warning
                            ? "Save soon to stay safe"
                            : "Streak lost, XP reduced")
                )
                .font(.caption2)
                .multilineTextAlignment(.center)
                .foregroundColor(
                    penaltyStatus == .warning
                        ? .orange.opacity(0.8)
                        : .pennySecondaryText
                )
            }

            Spacer(minLength: 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(14)
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
    }

    private var wishlistCard: some View {
        VStack(alignment: .center, spacing: 0) {
            let currentAmt = homeVM.goal?.currentAmount ?? 0
            let targetAmt = homeVM.goal?.targetAmount ?? 1
            let isGoalCompleted = currentAmt >= targetAmt && targetAmt > 0

            HStack {
                Label("Wishlist", systemImage: "target")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.pennyPurple)

                Spacer()

                if isGoalCompleted {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                        .font(.subheadline)
                }
            }

            Spacer(minLength: 8)

            VStack(spacing: 8) {
                Text(homeVM.goal?.itemName ?? "No Goal")
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                    .multilineTextAlignment(.center)

                if isGoalCompleted {
                    Button(action: { showNewGoalModal = true }) {
                        Text("Set New Goal")
                            .font(.caption2.weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(Color.green, in: Capsule())
                    }
                } else {
                    VStack(spacing: 6) {
                        ProgressView(value: currentAmt, total: targetAmt)
                            .tint(.blue)

                        Text(
                            "\(Int(currentAmt).formattedWithSeparator) / \(Int(targetAmt).formattedWithSeparator)"
                        )
                        .font(.caption2)
                        .foregroundColor(.pennySecondaryText)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    }
                }
            }

            Spacer(minLength: 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(14)
        .background(
            Color(UIColor.systemBackground),
            in: RoundedRectangle(cornerRadius: 20)
        )
    }

    // MARK: - Helper Functions (Firestore Sync)
    // 🌟 PERBAIKAN: Menangkap perubahan database item equipped dari koleksi inventories secara real-time
    private func startEquipmentListener() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("inventories").document(uid).addSnapshotListener {
            snapshot,
            error in
            if let error = error {
                print(
                    "Error listening to equipment: \(error.localizedDescription)"
                )
                return
            }

            if let data = snapshot?.data() {
                withAnimation(.spring()) {
                    self.equippedBackgroundId =
                        data["selectedBackgroundId"] as? String
                    self.equippedAccessoryId =
                        data["selectedAccessoryId"] as? String
                }
            }
        }
    }

    // 🌟 PERBAIKAN: Mengambil daftar katalog toko untuk mencocokkan ID dengan data detail item (Warna Hex, Icon, dll)
    private func fetchShopItems() {
        db.collection("shopItems").getDocuments { snapshot, error in
            if let error = error {
                print(
                    "Error fetching shop items: \(error.localizedDescription)"
                )
                return
            }

            if let documents = snapshot?.documents {
                self.shopItems = documents.compactMap { doc in
                    try? doc.data(as: ShopItemModel.self)
                }
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
