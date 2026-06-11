//
//  IOSConnectivityService.swift
//  PennyPalsWatchOS Watch App
//

import Foundation
import WatchConnectivity

protocol IOSConnectivityDelegate: AnyObject {
    func didReceiveUserUpdate(data: [String: Any])
    func didReceivePetUpdate(data: [String: Any])
    func didReceiveInventoryUpdate(data: [String: Any])
    func didReceiveLogout()
    func connectionStateChanged(isConnected: Bool)
}

class IOSConnectivityService: NSObject, WCSessionDelegate {
    static let shared = IOSConnectivityService()
    weak var delegate: IOSConnectivityDelegate?
    
    private override init() {
        super.init()
        activateSession()
    }
    
    private func activateSession() {
        guard WCSession.isSupported() else {
            print("⌚ WCSession not supported on this Watch")
            return
        }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func requestRefresh() {
        guard WCSession.default.isReachable else {
            print("⌚ iPhone not reachable for refresh request")
            return
        }
        WCSession.default.sendMessage(["request": "refresh"], replyHandler: nil) { error in
            print("⌚ Refresh request error: \(error.localizedDescription)")
        }
    }
    
    func equipBackground(id: String) {
        guard WCSession.default.isReachable else {
            print("⌚ iPhone not reachable for equip request")
            return
        }
        WCSession.default.sendMessage(["request": "equipBackground", "id": id], replyHandler: nil) { error in
            print("⌚ Equip background error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("⌚ WCSession activation failed: \(error.localizedDescription)")
            return
        }
        print("⌚ WCSession activated with state: \(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        processMessage(message)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        processMessage(applicationContext)
    }
    
    private func processMessage(_ data: [String: Any]) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.connectionStateChanged(isConnected: true)
            let messageType = data["type"] as? String ?? ""
            
            switch messageType {
            case "userUpdate":
                self?.delegate?.didReceiveUserUpdate(data: data)
            case "petUpdate":
                self?.delegate?.didReceivePetUpdate(data: data)
            case "inventoryUpdate":
                self?.delegate?.didReceiveInventoryUpdate(data: data)
            case "logout":
                self?.delegate?.didReceiveLogout()
            default:
                print("⌚ Unknown message type: \(messageType)")
            }
        }
    }
}
