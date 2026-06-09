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

/// ViewModel yang mengatur status autentikasi, manajemen sesi, dan profil akun pengguna.
/// Berkomunikasi langsung dengan Firebase Authentication dan dokumen koleksi `users` di Firestore.
@MainActor
class AuthViewModel: ObservableObject {

    /// Status apakah pengguna saat ini sedang terautentikasi (login) atau tidak.
    @Published var isAuthenticated = false

    /// Model data pengguna yang sedang aktif. Diperbarui secara otomatis melalui listener real-time dari Firestore.
    @Published var currentUser: UserModel?

    /// Pesan kesalahan lokal yang dapat diobservasi oleh View untuk memunculkan alert/error message.
    @Published var errorMessage: String?

    private var db = Firestore.firestore()

    init() {
        checkAuthStatus()
    }

    /// Memeriksa status sesi pengguna yang tersimpan secara lokal oleh Firebase Authentication.
    func checkAuthStatus() {
        if let user = Auth.auth().currentUser {
            self.isAuthenticated = true
            fetchUserData(uid: user.uid)
        } else {
            self.isAuthenticated = false
        }
    }

    /// Memperbarui nama tampilan (username) dari pengguna yang sedang login di database Firestore.
    /// - Parameter newUsername: Nama pengguna baru yang ingin disimpan.
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

    /// Memperbarui kata sandi pengguna saat ini di Firebase Authentication dengan enkripsi bawaan server.
    /// - Parameter newPassword: Kata sandi baru yang memenuhi kriteria keamanan minimum.
    func updatePassword(_ newPassword: String) async {
        do {
            try await Auth.auth().currentUser?.updatePassword(to: newPassword)
        } catch let error as NSError {
            if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                self.errorMessage =
                    "For security reasons, please log out and log in again before changing your password."
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    /// Memperbarui nama panggilan dari hewan peliharaan (virtual pet) milik pengguna aktif di Firestore.
    /// - Parameter newName: Nama baru untuk virtual pet.
    func updatePetName(_ newName: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            let snap = try await db.collection("pets")
                .whereField("userId", isEqualTo: uid)
                .limit(to: 1)
                .getDocuments()

            if let doc = snap.documents.first {
                try await db.collection("pets").document(doc.documentID)
                    .updateData([
                        "name": newName
                    ])
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    /// Mengambil nama panggilan hewan peliharaan virtual yang terikat dengan ID pengguna dari Firestore.
    /// - Returns: Mengembalikan string nama pet jika ditemukan, atau `nil` jika gagal/tidak ditemukan.
    func fetchPetName() async -> String? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        do {
            let snap = try await db.collection("pets")
                .whereField("userId", isEqualTo: uid)
                .limit(to: 1)
                .getDocuments()

            if let doc = snap.documents.first,
                let name = doc.data()["name"] as? String
            {
                return name
            }
        } catch {
            print("Error fetching pet name: \(error.localizedDescription)")
        }
        return nil
    }

    /// Melakukan proses masuk log (Login) menggunakan kredensial email dan kata sandi via Firebase Auth.
    /// - Parameters:
    ///   - email: Alamat email terdaftar pengguna.
    ///   - password: Kata sandi akun.
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

    /// Mendaftarkan akun pengguna baru (Register) serta melakukan inisialisasi awal skema dokumen profil pada Firestore.
    /// - Parameters:
    ///   - email: Alamat email baru yang valid.
    ///   - password: Kata sandi akun baru.
    ///   - username: Nama tampilan awal yang dipilih pengguna.
    func register(email: String, password: String, username: String) async {
        do {
            let result = try await Auth.auth().createUser(
                withEmail: email,
                password: password
            )

            // Inisialisasi tenggat waktu penalti (default: H+2 dari pendaftaran)
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

            // Mengaktifkan real-time listener sinkronisasi data sesaat setelah registrasi sukses
            fetchUserData(uid: result.user.uid)

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    /// Melakukan proses keluar log (Log out) untuk menghapus token sesi lokal, data cached Apple Watch, serta membatalkan seluruh push notifications.
    func logout() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
            self.currentUser = nil

            // Sinkronisasi status logout ke Apple Watch ekosistem
            PhoneConnectivity.shared.sendLogoutToWatch()

            // Membatalkan penalti/reminder push notifications lokal saat sesi berakhir
            NotificationManager.shared.cancelAllNotifications()
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }

    /// Mengubah atau memasang aset kosmetik dekoratif virtual (Background/Accessory) yang aktif pada profil pengguna.
    /// - Parameters:
    ///   - isBackground: Nilai boolean true untuk kategori Background, false untuk kategori Accessory.
    ///   - itemName: Nama file/identifikasi aset kosmetik unik yang dipilih.
    func equipItem(isBackground: Bool, itemName: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
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

    /// Melakukan sinkronisasi data profil terenkripsi dari Firestore ke internal state secara real-time.
    private func fetchUserData(uid: String) {
        // Menggunakan [weak self] untuk mencegah retain cycle / memory leak pada alokasi closure listener
        db.collection("users").document(uid).addSnapshotListener {
            [weak self] snapshot, error in
            guard let self = self else { return }

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
                    self.currentUser = try snapshot.data(as: UserModel.self)
                    print("✅ User data berhasil diupdate secara real-time!")

                    // Sinkronisasi pembaruan metrik gamifikasi secara instan ke WatchOS extension
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
                    // NOTE: Selama fase development, hindari memanggil self.logout() di sini
                    // agar Anda dapat memeriksa galat decoding skema properti langsung pada konsol Xcode.
                }
            }
        }
    }
}
