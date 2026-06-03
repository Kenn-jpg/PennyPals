//
//  PhoneConnectivity.swift
//  PennyPals
//
//  Created by Kelompok 8 on 03/06/26.
//

import WatchConnectivity
import Foundation

/// Singleton yang mengelola komunikasi iPhone → Apple Watch
/// Mengirim data user & pet ke Watch setiap kali ada perubahan dari Firestore
class PhoneConnectivity: NSObject {
    static let shared = PhoneConnectivity()

    private override init() {
        super.init()
    }

    // MARK: - Session Activation

    func activate() {
        guard WCSession.isSupported() else {
            print("⌚ WCSession not supported on this device")
            return
        }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    // MARK: - Send Data to Watch

    /// Kirim data user ke Watch — panggil ini setiap kali Firestore snapshot update
    func sendUserToWatch(
        username: String,
        email: String,
        coins: Int,
        streak: Int,
        totalSavings: Int,
        isSafeFromPenalty: Bool,
        nextPenaltyCheck: Date
    ) {
        let data: [String: Any] = [
            "type": "userUpdate",
            "username": username,
            "email": email,
            "coins": coins,
            "streak": streak,
            "totalSavings": totalSavings,
            "isSafeFromPenalty": isSafeFromPenalty,
            "nextPenaltyCheck": nextPenaltyCheck.timeIntervalSince1970,
        ]
        sendToWatch(data)
    }

    /// Kirim data pet ke Watch — panggil ini setiap kali pet Firestore snapshot update
    func sendPetToWatch(
        name: String,
        level: Int,
        xp: Int,
        maxXP: Int,
        mood: String,
        type: String
    ) {
        let data: [String: Any] = [
            "type": "petUpdate",
            "petName": name,
            "petLevel": level,
            "petXP": xp,
            "petMaxXP": maxXP,
            "petMood": mood,
            "petType": type,
        ]
        sendToWatch(data)
    }

    // MARK: - Private Helpers

    private func sendToWatch(_ data: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            print("⌚ WCSession not activated yet, skipping send")
            return
        }

        // 1. Real-time: sendMessage (requires Watch app reachable)
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(data, replyHandler: nil) { error in
                print("⌚ sendMessage error: \(error.localizedDescription)")
            }
        }

        // 2. Guaranteed: transferUserInfo (queued, delivered even if Watch app not running)
        WCSession.default.transferUserInfo(data)
    }
}

// MARK: - WCSessionDelegate

extension PhoneConnectivity: WCSessionDelegate {

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        if let error = error {
            print("⌚ iPhone WCSession activation error: \(error.localizedDescription)")
        } else {
            print("⌚ iPhone WCSession activated: \(activationState.rawValue)")
        }
    }

    // Required for iOS (not needed on watchOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("⌚ WCSession became inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Re-activate for Watch switching scenarios
        WCSession.default.activate()
    }

    // Handle incoming messages from Watch (e.g. refresh request)
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        if message["request"] as? String == "refresh" {
            print("⌚ Watch requested data refresh")
            // Post notification so ViewModels can respond
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .watchRequestedRefresh,
                    object: nil
                )
            }
        }
    }
}

// MARK: - Notification Name

extension Notification.Name {
    static let watchRequestedRefresh = Notification.Name("watchRequestedRefresh")
}
