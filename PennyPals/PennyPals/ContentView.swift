//
//  ContentView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

enum AppStage {
    case onboarding, hatching, app
}

enum TabItem: String, CaseIterable {
    case home = "Home"
    case shop = "Shop"
    case account = "Account"

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .shop: return "bag.fill"
        case .account: return "person.fill"
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel

    @State private var stage: AppStage = .app
    @State private var selectedTab: TabItem = .home

    /// ViewModel onboarding dimiliki oleh ContentView agar ID telur yang dipilih tetap bisa diakses oleh HatchingView.
    @StateObject private var onboardingVM = OnboardingViewModel()

    var body: some View {
        Group {
            if authVM.isAuthenticated {
                if let user = authVM.currentUser {
                    switch stage {
                    case .onboarding:
                        OnboardingView(
                            onStart: {
                                // Transisikan ke hatching terlebih dahulu secara lokal
                                // agar blok .onReceive tidak memotong urutan animasi saat Firestore terupdate!
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    stage = .hatching
                                }
                            }
                        )
                        .environmentObject(onboardingVM)
                        .transition(.move(edge: .trailing))

                    case .hatching:
                        HatchingView(
                            eggId: onboardingVM.selectedEgg,
                            onComplete: {
                                withAnimation(.spring()) { stage = .app }
                            }
                        )
                        .transition(.opacity)

                    case .app:
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            let listSelection = Binding<TabItem?>(
                                get: { selectedTab },
                                set: { if let val = $0 { selectedTab = val } }
                            )

                            NavigationSplitView {
                                List(
                                    TabItem.allCases,
                                    id: \.self,
                                    selection: listSelection
                                ) { tab in
                                    NavigationLink(value: tab) {
                                        Label(
                                            tab.rawValue,
                                            systemImage: tab.icon
                                        )
                                    }
                                }
                                .navigationTitle("PennyPals")
                            } detail: {
                                switch selectedTab {
                                case .home:
                                    // Menyertakan closure penanganan klik profil untuk iPad layout
                                    HomeView(onProfilePictureTapped: {
                                        withAnimation {
                                            selectedTab = .account
                                        }
                                    })
                                case .shop:
                                    ShopView()
                                case .account:
                                    AccountView(onLogout: { authVM.logout() })
                                }
                            }
                            .tint(Color.pennyPurple)
                            .transition(.opacity)
                        } else {
                            TabView(selection: $selectedTab) {
                                // Menyertakan closure penanganan klik profil untuk iPhone layout
                                HomeView(onProfilePictureTapped: {
                                    withAnimation {
                                        selectedTab = .account
                                    }
                                })
                                .tabItem {
                                    Label("Home", systemImage: "house.fill")
                                }
                                .tag(TabItem.home)

                                ShopView()
                                    .tabItem {
                                        Label("Shop", systemImage: "bag.fill")
                                    }
                                    .tag(TabItem.shop)

                                AccountView(onLogout: {
                                    authVM.logout()
                                })
                                .tabItem {
                                    Label("Account", systemImage: "person.fill")
                                }
                                .tag(TabItem.account)
                            }
                            .tint(Color.pennyPurple)
                            .toolbarBackground(.visible, for: .tabBar)
                            .toolbarBackground(
                                Color(UIColor.systemBackground),
                                for: .tabBar
                            )
                            .transition(.opacity)
                        }
                    }
                } else {
                    // Loading Screen saat AuthViewModel sedang addSnapshotListener pertama kali
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading your pal...")
                            .foregroundColor(.pennySecondaryText)
                            .padding(.top, 16)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.pennyBackground.ignoresSafeArea())
                }

            } else {
                LoginView(onLoginSuccess: { _ in
                    // Reset semua state input form onboarding saat ada user baru login
                    onboardingVM.resetForm()
                })
                .transition(.opacity)
            }
        }
        .onReceive(authVM.$currentUser) { user in
            guard let user = user else { return }

            // Logika Router Otomatis berdasarkan status Onboarding di DB
            if user.isOnboarded == false {
                if stage == .app {
                    stage = .onboarding
                }
            } else if user.isOnboarded == true && stage == .onboarding {
                // Skenario jika user login ulang dan ternyata sudah pernah onboarding sebelumnya
                stage = .app
            }
        }
    }
}
