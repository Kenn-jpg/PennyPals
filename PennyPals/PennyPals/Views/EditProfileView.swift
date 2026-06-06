//
//  EditProfileView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var username: String = ""
    @State private var petName: String = ""

    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""

    @State private var isSaving = false
    @State private var localError: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Username")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.pennySecondaryText)

                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.horizontal, 16)
                        .frame(height: 48)
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Pet Name")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.pennySecondaryText)

                    TextField("Pet Name", text: $petName)
                        .padding(.horizontal, 16)
                        .frame(height: 48)
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("New Password")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.pennySecondaryText)

                    SecureField("New Password", text: $newPassword)
                        .padding(.horizontal, 16)
                        .frame(height: 48)
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding(.horizontal, 16)
                        .frame(height: 48)
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                if let msg = (localError ?? authVM.errorMessage) {
                    Text(msg)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button {
                    Task { await save() }
                } label: {
                    Text(isSaving ? "Saving..." : "Save Changes")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(isSaving ? Color.gray : Color.pennyPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(isSaving)

                Spacer(minLength: 0)
            }
            .padding()
            .background(Color.pennyBackground.ignoresSafeArea())
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .onAppear {
                username = authVM.currentUser?.username ?? ""
                Task { await loadPetName() }
            }
        }
    }

    private func loadPetName() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        do {
            let snap = try await db.collection("pets")
                .whereField("userId", isEqualTo: uid)
                .limit(to: 1)
                .getDocuments()

            if let doc = snap.documents.first,
                let name = doc.data()["name"] as? String
            {
                petName = name
            }
        } catch {
            // optional: tampilkan error jika mau
        }
    }

    @MainActor
    private func save() async {
        localError = nil
        authVM.errorMessage = nil

        let trimmedUsername = username.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let trimmedPetName = petName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        // validasi password hanya kalau user isi
        if !newPassword.isEmpty || !confirmPassword.isEmpty {
            guard newPassword == confirmPassword else {
                localError = "Password confirmation does not match."
                return
            }
            guard newPassword.count >= 6 else {
                localError = "Password must be at least 6 characters."
                return
            }
        }

        isSaving = true
        defer { isSaving = false }

        // 1) update username (Firestore users)
        if !trimmedUsername.isEmpty {
            await authVM.updateUsername(trimmedUsername)
        }

        // 2) update pet name (Firestore pets)
        if !trimmedPetName.isEmpty {
            await updatePetName(trimmedPetName)
        }

        // 3) update password (FirebaseAuth)
        if !newPassword.isEmpty {
            await authVM.updatePassword(newPassword)
        }

        if authVM.errorMessage == nil && localError == nil {
            dismiss()
        }
    }

    private func updatePetName(_ newName: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        do {
            let snap = try await db.collection("pets")
                .whereField("userId", isEqualTo: uid)
                .limit(to: 1)
                .getDocuments()

            guard let doc = snap.documents.first else {
                await MainActor.run { localError = "Pet not found." }
                return
            }

            try await db.collection("pets").document(doc.documentID).updateData(
                [
                    "name": newName
                ])
        } catch {
            await MainActor.run { localError = error.localizedDescription }
        }
    }
}
