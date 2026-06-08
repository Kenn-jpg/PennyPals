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
        
        let colorHex = currentBg?["colorHex"] ?? "#FFF1F6"
        let spotsHex = currentBg?["spotsHex"] ?? "#E8F4FF"
        
        return LinearGradient(
            colors: [Color(hex: colorHex), Color(hex: spotsHex)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        TabView {
            // MARK: - 1. Pet Stats Tab
            WatchPetStatsView()
                .containerBackground(
                    backgroundGradient,
                    for: .tabView
                )

            // MARK: - 2. Profile Tab
            WatchProfileView()
                .containerBackground(
                    backgroundGradient,
                    for: .tabView
                )

            // MARK: - 3. Settings Tab
            WatchSettingsView()
                .containerBackground(
                    backgroundGradient,
                    for: .tabView
                )
        }
        .tabViewStyle(.page)
        .onAppear {
            connectivity.requestRefresh()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(IOSConnectivity())
}
