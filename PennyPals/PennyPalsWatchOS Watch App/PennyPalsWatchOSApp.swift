//
//  PennyPalsWatchOSApp.swift
//  PennyPalsWatchOS Watch App
//
//  Created by Keane Juan Suryanto on 02/06/26.
//

import SwiftUI

@main
struct PennyPalsWatchOS_Watch_AppApp: App {
    @StateObject private var connectivity = IOSConnectivity()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(connectivity)
        }
    }
}
