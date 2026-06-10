
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
