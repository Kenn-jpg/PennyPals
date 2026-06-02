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
                isSafeFromPenalty: true,
                nextPenaltyCheck: nextCheck,
                isOnboarded: false  // <--- TAMBAHKAN BARIS INI
            )
            try db.collection("users").document(result.user.uid).setData(
                from: newUser
            )
            self.currentUser = newUser
            self.isAuthenticated = true
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
        db.collection("users").document(uid).addSnapshotListener {
            snapshot,
            error in
            if let error = error {
                print("❌ Firestore Error: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else { return }

            // PROTEKSI 1: Jika dokumen tidak ada di Firestore (Akun Hantu)
            if !snapshot.exists {
                print("❌ Dokumen user tidak ditemukan! Logout otomatis...")
                self.logout()
                return
            }

            // PROTEKSI 2: Mencari tahu error dari strukturnya
            do {
                self.currentUser = try snapshot.data(as: UserModel.self)
            } catch {
                print("❌ DECODING ERROR PADA USERMODEL: \(error)")
                // Jika error, kita force logout agar tidak stuck di loading
                self.logout()
            }
        }
    }
}
