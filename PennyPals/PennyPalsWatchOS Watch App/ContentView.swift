//
//  ContentView.swift
//  PennyPalsWatchOS Watch App
//
//  Created by Keane Juan Suryanto on 02/06/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var connectivity: IOSConnectivity
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = WatchTheme.midnight.rawValue

    private var currentTheme: WatchTheme {
        WatchTheme(rawValue: selectedThemeRaw) ?? .midnight
    }

    var body: some View {
        TabView {
            // Tab 1: Pet Stats
            WatchPetStatsView()
                .containerBackground(
                    currentTheme.gradient,
                    for: .tabView
                )

            // Tab 2: Profile
            WatchProfileView()
                .containerBackground(
                    currentTheme.gradient,
                    for: .tabView
                )

            // Tab 3: Settings
            WatchSettingsView()
                .containerBackground(
                    currentTheme.gradient,
                    for: .tabView
                )
        }
        .tabViewStyle(.verticalPage)
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
