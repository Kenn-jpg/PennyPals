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
    @State private var stage: AppStage = .login
    @State private var initialSavings: String = ""
    @State private var selectedEggId: String = "rose"

    var body: some View {
        Group {
            switch stage {
            case .login:
                LoginView(onLogin: {
                    withAnimation(.spring()) { stage = .onboarding }
                })
                .transition(.opacity)

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
                    HomeView(savingsAmount: initialSavings)
                        .tabItem { Label("Home", systemImage: "house.fill") }

                    ShopView()
                        .tabItem { Label("Shop", systemImage: "bag.fill") }

                    AccountView(onLogout: {
                        initialSavings = ""
                        selectedEggId = "rose"
                        withAnimation(.spring()) { stage = .login }
                    })
                    .tabItem { Label("Account", systemImage: "person.fill") }
                }
                .tint(Color.pennyPurple)
                // Memaksa Navbar/TabBar bawah selalu solid dan tidak transparan
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(
                    Color(UIColor.systemBackground),
                    for: .tabBar
                )
                .transition(.opacity)
            }
        }
    }
}
