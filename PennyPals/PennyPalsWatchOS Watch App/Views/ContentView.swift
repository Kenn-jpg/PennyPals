//
//  ContentView.swift
//  PennyPalsWatchOS Watch App
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WatchViewModel

    var body: some View {
        TabView {
            // MARK: - 1. Pet Stats Tab
            WatchPetStatsView()
                .containerBackground(
                    viewModel.backgroundGradient,
                    for: .tabView
                )

            // MARK: - 2. Profile Tab
            WatchProfileView()
                .containerBackground(
                    viewModel.backgroundGradient,
                    for: .tabView
                )

            // MARK: - 3. Settings Tab
            WatchSettingsView()
                .containerBackground(
                    viewModel.backgroundGradient,
                    for: .tabView
                )
        }
        .tabViewStyle(.page)
        .onAppear {
            viewModel.requestRefresh()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WatchViewModel())
}
