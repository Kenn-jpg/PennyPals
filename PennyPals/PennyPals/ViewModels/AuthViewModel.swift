//
//  AuthViewModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

internal import Combine
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: UserModel?
    
    @Published var errorMessage: String?
    private var db = Firestore.firestore()

    init() { checkAuthStatus() }

    func checkAuthStatus() {
        if let user = Auth.auth().currentUser {
            self.isAuthenticated = true
            fetchUserData(uid: user.uid)
        } else {
            self.isAuthenticated = false
        }
    }
    

    func updateUsername(_ newUsername: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            try await db.collection("users").document(uid).updateData([
                "username": newUsername
            ])
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func updatePassword(_ newPassword: String) async {
        do {
            try await Auth.auth().currentUser?.updatePassword(to: newPassword)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func login(email: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(
                withEmail: email,
                password: password
            )
            self.isAuthenticated = true
            fetchUserData(uid: result.user.uid)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func register(email: String, password: String, username: String) async {
        do {
            let result = try await Auth.auth().createUser(
                withEmail: email,
                password: password
            )
            let nextCheck = Calendar.current.date(
                byAdding: .day,
                value: 2,
                to: Date()
            )!
            let newUser = UserModel(
                id: result.user.uid,
                username: username,
                email: email,
                coins: 0,
                streak: 0,
                lastLoginDate: Date(),
                createdAt: Date(),
                totalSavings: 0,
                isSafeFromPenalty: true,
                nextPenaltyCheck: nextCheck,
                isOnboarded: false
            )
            try db.collection("users").document(result.user.uid).setData(
                from: newUser
            )

            self.currentUser = newUser
            self.isAuthenticated = true

            // 🌟 TAMBAHKAN BARIS INI: Aktifkan listener real-time langsung setelah register selesai!
            fetchUserData(uid: result.user.uid)

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
            self.currentUser = nil
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }

    private func fetchUserData(uid: String) {
        // Tambahkan [weak self] agar tidak terjadi memory leak
        db.collection("users").document(uid).addSnapshotListener {
            [weak self] snapshot, error in
            guard let self = self else { return }

            // Bungkus ke Main Thread agar SwiftUI sadar ada perubahan data!
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Firestore Error: \(error.localizedDescription)")
                    return
                }

                guard let snapshot = snapshot, snapshot.exists else {
                    print("❌ Dokumen user tidak ditemukan! Logout otomatis...")
                    self.logout()
                    return
                }

                do {
                    // Update currentUser yang akan memicu perubahan di HomeView
                    self.currentUser = try snapshot.data(as: UserModel.self)
                    print("✅ User data berhasil diupdate secara real-time!")

                    // 📲 Forward data ke Apple Watch
                    if let user = self.currentUser {
                        PhoneConnectivity.shared.sendUserToWatch(
                            username: user.username,
                            email: user.email,
                            coins: user.coins,
                            streak: user.streak,
                            totalSavings: user.totalSavings,
                            isSafeFromPenalty: user.isSafeFromPenalty,
                            nextPenaltyCheck: user.nextPenaltyCheck
                        )
                    }
                } catch {
                    print("❌ DECODING ERROR PADA USERMODEL: \(error)")
                    // TIPS: Jangan panggil self.logout() dulu saat masih tahap development,
                    // supaya kamu bisa melihat errornya di konsol Xcode tanpa terlempar ke layar login.
                }
            }
        }
    }
}
