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
    @State private var wishlistName: String = ""

    // --- TAMBAHAN BARU: State untuk menampung nominal target/harga wishlist ---
    @State private var targetAmountString: String = ""

    var body: some View {
        Group {
            if authVM.isAuthenticated {
                if let user = authVM.currentUser {
                    switch stage {
                    case .onboarding:
                        OnboardingView(
                            rawAmount: $initialSavings,
                            selectedEgg: $selectedEggId,
                            wishlistName: $wishlistName,
                            targetAmountString: $targetAmountString,  // --- Binding data diteruskan ke sini ---
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
                    self.initialSavings = ""
                    self.selectedEggId = "rose"
                    self.wishlistName = ""
                    self.targetAmountString = ""  // --- Reset juga saat user baru login ---
                })
                .transition(.opacity)
            }
        }
        .onReceive(authVM.$currentUser) { user in
            guard let user = user else { return }

            if user.isOnboarded == false || user.isOnboarded == nil {
                if stage == .app {
                    stage = .onboarding
                }
            } else if user.isOnboarded == true && stage == .onboarding {
                stage = .app
            }
        }
    }
}
