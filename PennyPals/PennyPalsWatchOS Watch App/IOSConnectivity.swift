//
//  IOSConnectivity.swift
//  PennyPalsWatchOS Watch App
//
//  Created by Kelompok 8 on 03/06/26.
//

import WatchConnectivity
import Foundation
import Combine

/// ObservableObject yang menerima data dari iPhone via WatchConnectivity
/// Semua @Published properties otomatis update UI Watch saat data masuk
class IOSConnectivity: NSObject, ObservableObject {

    // MARK: - User Data
    @Published var username: String = "—"
    @Published var email: String = "—"
    @Published var coins: Int = 0
    @Published var streak: Int = 0
    @Published var totalSavings: Int = 0
    @Published var isSafeFromPenalty: Bool = true
    @Published var nextPenaltyCheck: Date = Date()

    // MARK: - Pet Data
    @Published var petName: String = "Pal"
    @Published var petLevel: Int = 0
    @Published var petXP: Int = 0
    @Published var petMaxXP: Int = 200
    @Published var petMood: String = "hungry"
    @Published var petType: String = "rose"

    // MARK: - Connection Status
    @Published var isConnected: Bool = false

    override init() {
        super.init()
        activateSession()
    }

    // MARK: - Session Activation

    private func activateSession() {
        guard WCSession.isSupported() else {
            print("⌚ WCSession not supported on this Watch")
            return
        }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    // MARK: - Request Refresh from iPhone

    /// Kirim permintaan ke iPhone untuk mengirim data terbaru
    func requestRefresh() {
        guard WCSession.default.isReachable else {
            print("⌚ iPhone not reachable for refresh request")
            return
        }
        WCSession.default.sendMessage(
            ["request": "refresh"],
            replyHandler: nil
        ) { error in
            print("⌚ Refresh request error: \(error.localizedDescription)")
        }
    }

    // MARK: - Process Incoming Data

    private func processMessage(_ data: [String: Any]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let messageType = data["type"] as? String ?? ""

            switch messageType {
            case "userUpdate":
                if let username = data["username"] as? String {
                    self.username = username
                }
                if let email = data["email"] as? String {
                    self.email = email
                }
                if let coins = data["coins"] as? Int {
                    self.coins = coins
                }
                if let streak = data["streak"] as? Int {
                    self.streak = streak
                }
                if let totalSavings = data["totalSavings"] as? Int {
                    self.totalSavings = totalSavings
                }
                if let isSafe = data["isSafeFromPenalty"] as? Bool {
                    self.isSafeFromPenalty = isSafe
                }
                if let nextCheck = data["nextPenaltyCheck"] as? TimeInterval {
                    self.nextPenaltyCheck = Date(timeIntervalSince1970: nextCheck)
                }
                self.isConnected = true
                print("⌚ Watch received user update: \(self.username)")

            case "petUpdate":
                if let name = data["petName"] as? String {
                    self.petName = name
                }
                if let level = data["petLevel"] as? Int {
                    self.petLevel = level
                }
                if let xp = data["petXP"] as? Int {
                    self.petXP = xp
                }
                if let maxXP = data["petMaxXP"] as? Int {
                    self.petMaxXP = maxXP
                }
                if let mood = data["petMood"] as? String {
                    self.petMood = mood
                }
                if let type = data["petType"] as? String {
                    self.petType = type
                }
                self.isConnected = true
                print("⌚ Watch received pet update: \(self.petName) Lv.\(self.petLevel)")

            default:
                print("⌚ Unknown message type: \(messageType)")
            }
        }
    }
}

// MARK: - WCSessionDelegate

extension IOSConnectivity: WCSessionDelegate {

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        DispatchQueue.main.async {
            if let error = error {
                print("⌚ Watch WCSession activation error: \(error.localizedDescription)")
                self.isConnected = false
            } else {
                print("⌚ Watch WCSession activated: \(activationState.rawValue)")
                self.isConnected = activationState == .activated
                // Request data terbaru dari iPhone saat pertama kali connect
                self.requestRefresh()
            }
        }
    }

    // Real-time messages dari iPhone (saat app reachable)
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        processMessage(message)
    }

    // Guaranteed delivery messages (queued via transferUserInfo)
    func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String: Any] = [:]
    ) {
        processMessage(userInfo)
    }
}
