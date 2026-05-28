//
//  AuthViewModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

internal import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: UserModel?
    @Published var errorMessage: String?

    private var db = Firestore.firestore()

    init() {
        checkAuthStatus()
    }

    func checkAuthStatus() {
        if let user = Auth.auth().currentUser {
            self.isAuthenticated = true
            fetchUserData(uid: user.uid)
        } else {
            self.isAuthenticated = false
        }
    }

    // MARK: - Email Authentication
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

            // Buat data user baru di Firestore
            let newUser = UserModel(
                id: result.user.uid,
                username: username,
                email: email,
                coins: 0,
                streak: 0,
                lastLoginDate: Date(),
                createdAt: Date(),
                isSafeFromPenalty: true,
                nextPenaltyCheck: Calendar.current.date(
                    byAdding: .day,
                    value: 2,
                    to: Date()
                )!
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
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch User Data
    private func fetchUserData(uid: String) {
        db.collection("users").document(uid).addSnapshotListener {
            documentSnapshot,
            error in
            guard let document = documentSnapshot else { return }
            self.currentUser = try? document.data(as: UserModel.self)
        }
    }
}
