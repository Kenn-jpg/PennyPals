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

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel

    @State private var stage: AppStage = .app
    @State private var initialSavings: String = ""
    @State private var selectedEggId: String = "rose"

    var body: some View {
        Group {
            // 1. CEK STATUS LOGIN TERLEBIH DAHULU
            if authVM.isAuthenticated {

                // 2. CEK APAKAH DATA USER SUDAH SELESAI DIDOWNLOAD DARI FIRESTORE
                if let user = authVM.currentUser {
                    switch stage {
                    case .onboarding:
                        OnboardingView(
                            rawAmount: $initialSavings,
                            selectedEgg: $selectedEggId,
                            onStart: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    stage = .hatching
                                }
                            }
                        )
                        .transition(.move(edge: .trailing))

                    case .hatching:
                        HatchingView(
                            eggId: selectedEggId,
                            onComplete: {
                                withAnimation(.spring()) { stage = .app }
                            }
                        )
                        .transition(.opacity)

                    case .app:
                        TabView {
                            HomeView().tabItem {
                                Label("Home", systemImage: "house.fill")
                            }
                            ShopView().tabItem {
                                Label("Shop", systemImage: "bag.fill")
                            }
                            AccountView(onLogout: {
                                authVM.logout()
                            }).tabItem {
                                Label("Account", systemImage: "person.fill")
                            }
                        }
                        .tint(Color.pennyPurple)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarBackground(
                            Color(UIColor.systemBackground),
                            for: .tabBar
                        )
                        .transition(.opacity)
                    }
                } else {
                    // LAYAR LOADING: Hanya muncul beberapa detik saat transisi mengambil data profil
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
                // 3. JIKA BELUM LOGIN (Langsung lempar ke layar Login)
                LoginView(onLoginSuccess: { _ in
                    // Reset field saat pindah
                    self.initialSavings = ""
                    self.selectedEggId = "rose"
                })
                .transition(.opacity)
            }
        }
        // --- GUARDING LOGIC (Mencegah Bypass Bug) ---
        .onReceive(authVM.$currentUser) { user in
            guard let user = user else { return }

            // Jika user belum selesai Onboarding (false/nil), paksa layar ke Onboarding
            if user.isOnboarded == false || user.isOnboarded == nil {
                if stage == .app {
                    stage = .onboarding
                }
            } else if user.isOnboarded == true && stage == .onboarding {
                // Safety check: Jika dia sudah onboarded tapi nyangkut di stage onboarding, pindahkan ke Home
                stage = .app
            }
        }
    }
}
