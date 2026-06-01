//
//  ContentView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

enum AppStage {
    case login, onboarding, hatching, app
}

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var stage: AppStage = .login
    @State private var initialSavings: String = ""
    @State private var selectedEggId: String = "rose"

    var body: some View {
        Group {
            if authVM.isAuthenticated {
                switch stage {
                case .login:
                    Color.pennyBackground.ignoresSafeArea().onAppear {
                        stage = .app
                    }
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
                            stage = .login
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
                LoginView(onLoginSuccess: { isNewUser in
                    withAnimation(.spring()) {
                        stage = isNewUser ? .onboarding : .app
                    }
                })
                .transition(.opacity)
            }
        }
    }
}
