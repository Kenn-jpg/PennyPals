//
//  ContentView.swift
//  PennyPalsWatchOS Watch App
//
//  Created by Keane Juan Suryanto on 02/06/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var connectivity: IOSConnectivity

    private var backgroundGradient: LinearGradient {
        let selectedId = connectivity.selectedBackgroundId
        let bgs = connectivity.ownedBackgrounds
        let currentBg = bgs.first(where: { $0["id"] == selectedId })
        
        let colorHex = currentBg?["colorHex"] ?? "#1A1A2E"
        let spotsHex = currentBg?["spotsHex"] ?? "#16213E"
        
        return LinearGradient(
            colors: [Color(hex: colorHex), Color(hex: spotsHex)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        TabView {
            // Tab 1: Pet Stats
            WatchPetStatsView()
                .containerBackground(
                    backgroundGradient,
                    for: .tabView
                )

            // Tab 2: Profile
            WatchProfileView()
                .containerBackground(
                    backgroundGradient,
                    for: .tabView
                )

            // Tab 3: Settings
            WatchSettingsView()
                .containerBackground(
                    backgroundGradient,
                    for: .tabView
                )
        }
        .tabViewStyle(.page)
        .onAppear {
            // Request data terbaru saat Watch app dibuka
            connectivity.requestRefresh()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(IOSConnectivity())
}
