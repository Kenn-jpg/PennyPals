//
//  PennyPalsWatchOSApp.swift
//  PennyPalsWatchOS Watch App
//

import SwiftUI

@main
struct PennyPalsWatchOS_Watch_AppApp: App {
    // Gunakan ViewModel yang baru dibuat
    @StateObject private var watchViewModel = WatchViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(watchViewModel)
        }
    }
}
