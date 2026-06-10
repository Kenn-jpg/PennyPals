                                                                    hnghasilkan pesan teks interaktif dari peliharaan berdasarkan kondisi emosionalnya (mood).
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

                                                                    /// Bagian atas layar yang berisi ucapan selamat datang, level pet, dan koin pengguna.
                                                                    private var headerSection: some View {
                                                                        HStack {
                                                                            HStack {
                                                                                // Profile Picture dijadikan Button yang memicu aksi redirect
                                                                                Button(action: {
                                                                                    onProfilePictureTapped?()
                                                                                }) {
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
                                                                                }
                                                                                .buttonStyle(PlainButtonStyle())

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

                                                                    /// Area tengah yang menampilkan grafis hewan peliharaan, background, aksesoris, dan pesan interaktif.
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
                                                                                    if let bg = homeVM.equippedBackground {
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

                                                                                            // Render corak (spots) pada background jika tersedia
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
                                                                                        .clipped()
                                                                                        .clipShape(Circle())
                                                                                        .shadow(
                                                                                            color: .black.opacity(0.08),
                                                                                            radius: 10,
                                                                                            x: 0,
                                                                                            y: 4
                                                                                        )

                                                                                    } else {
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

                                                                                    PetView(
                                                                                        petType: homeVM.pet?.type ?? "Cat",
                                                                                        mood: homeVM.pet?.mood ?? "hungry",
                                                                                        size: 180
                                                                                    )

                                                                                    if let acc = homeVM.equippedAccessory {
                                                                                        Image(systemName: acc.imageName ?? "tshirt.fill")
                                                                                            .resizable()
                                                                                            .scaledToFit()
                                                                                            .frame(width: 85, height: 85)
                                                                                            .foregroundColor(.pennyPurple)
                                                                                            .offset(y: -25)
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

                                                                    /// Kumpulan kartu informasi di bagian bawah layar (Total Savings, XP Progress, Penalty, Wishlist).
                                                                    private var dashboardCardsSection: some View {
                                                                        VStack(spacing: 16) {

                                                                            // Kartu Total Tabungan
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

                                                                            // Kartu XP Progress
                                                                            VStack(spacing: 8) {
                                                                                HStack {
                                                                                    Text("\(homeVM.pet?.name ?? "Pet") XP")
                                                                                        .font(.subheadline.weight(.medium))
                                                                                        .foregroundColor(.pennySecondaryText)
struct PennyPalsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 8) {
            // MARK: - 5. Header Component
            HStack {
                Text(entry.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 42/255, green: 36/255, blue: 64/255))
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                
                Spacer()
                
                Text(moodEmoji(entry.mood))
                    .font(.system(size: 20))
            }
            
            // MARK: - 6. Level Badge
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(Color(red: 155/255, green: 124/255, blue: 255/255))
                Text("Level \(entry.level)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 42/255, green: 36/255, blue: 64/255))
                Spacer()
            }
            
            // MARK: - 7. XP Progress Bar
            VStack(spacing: 4) {
                HStack {
                    Text("XP")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(entry.xp) / \(entry.maxXP)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(red: 155/255, green: 124/255, blue: 255/255))
                }
                