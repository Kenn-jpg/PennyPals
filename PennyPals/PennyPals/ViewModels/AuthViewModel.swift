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

// ViewModel yang mengatur status autentikasi dan manajemen akun pengguna.
// Berkomunikasi langsung dengan Firebase Authentication dan koleksi `users` di Firestore.
@MainActor
class AuthViewModel: ObservableObject {
    // MARK: - Properties

    // Status apakah pengguna saat ini sedang login atau tidak.
    @Published var isAuthenticated = false
    
    // Model data pengguna yang sedang login saat ini. Akan diperbarui otomatis jika ada perubahan di Firestore.
    @Published var currentUser: UserModel?

    // Pesan error yang bisa ditampilkan di UI jika proses autentikasi gagal.
    @Published var errorMessage: String?
    private var db = Firestore.firestore()

    // MARK: - Initialization

    init() { checkAuthStatus() }

    // MARK: - 1. Session & Realtime Data

    // Mengecek apakah ada *session* pengguna yang tersimpan secara lokal oleh Firebase Auth.
    // Jika ada, akan otomatis mengambil data dari Firestore dan masuk ke aplikasi utama.
    func checkAuthStatus() {
        if let user = Auth.auth().currentUser {
            self.isAuthenticated = true
            fetchUserData(uid: user.uid)
        } else {
            self.isAuthenticated = false
        }
    }

    // MARK: - 2. Update Profile

    // Memperbarui nama pengguna (username) dari akun yang sedang login di Firestore.
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

    // Mengganti kata sandi (password) dari akun pengguna saat ini di Firebase Authentication.
    func updatePassword(_ newPassword: String) async {
        do {
            try await Auth.auth().currentUser?.updatePassword(to: newPassword)
        } catch let error as NSError {
            if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                self.errorMessage = "For security reasons, please log out and log in again before changing your password."
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // Memperbarui nama peliharaan (Pet Name) milik pengguna di dalam database.
    func updatePetName(_ newName: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            let snap = try await db.collection("pets")
                .whereField("userId", isEqualTo: uid)
                .limit(to: 1)
                .getDocuments()

            if let doc = snap.documents.first {
                try await db.collection("pets").document(doc.documentID).updateData([
                    "name": newName
                ])
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    // Mengambil nama peliharaan milik pengguna dari database Firestore.
    func fetchPetName() async -> String? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        do {
            let snap = try await db.collection("pets")
                .whereField("userId", isEqualTo: uid)
                .limit(to: 1)
                .getDocuments()

            if let doc = snap.documents.first,
               let name = doc.data()["name"] as? String {
                return name
            }
        } catch {
            print("Error fetching pet name: \(error.localizedDescription)")
        }
        return nil
    }

    // MARK: - 3. Authentication Operations

    // Masuk (Login) menggunakan email dan kata sandi yang terdaftar.
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

    // Mendaftar akun baru (Register) di Firebase Authentication dan membuat dokumen baru di Firestore.
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
                isOnboarded: false,
                equippedBackground: nil,
                equippedAccessory: nil
            )
            try db.collection("users").document(result.user.uid).setData(
                from: newUser
            )

            self.currentUser = newUser
            self.isAuthenticated = true

            // Aktifkan listener real-time langsung setelah register selesai
            fetchUserData(uid: result.user.uid)

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    // Mengeluarkan pengguna (Log out) dari aplikasi dan menghapus data sesi.
    func logout() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
            self.currentUser = nil
            // 📲 Beritahu WatchOS untuk menghapus data cached
            PhoneConnectivity.shared.sendLogoutToWatch()
            // 🔕 Batalkan semua notifikasi saat logout
            NotificationManager.shared.cancelAllNotifications()
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }


    func equipItem(isBackground: Bool, itemName: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // Tentukan field mana yang akan diupdate
        let field = isBackground ? "equippedBackground" : "equippedAccessory"

        db.collection("users").document(uid).updateData([
            field: itemName
        ]) { error in
            if let error = error {
                print("Error equipping item: \(error.localizedDescription)")
            } else {
                print("Successfully equipped \(itemName)!")
            }
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
