//
//  PennyPalsWatchOSApp.swift
//  PennyPalsWatchOS Watch App
//
//  Created by Keane Juan Suryanto on 02/06/26.
//

import SwiftUI

// MARK: - 1. Main App
@main
struct PennyPalsWatchOS_Watch_AppApp: App {
    @StateObject private var connectivity = IOSConnectivity()

    // MARK: - 2. Scene
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(connectivity)
        }
    }
}
