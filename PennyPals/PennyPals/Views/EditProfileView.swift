//
//  EditProfileView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import FirebaseAuth
import SwiftUI

struct EditProfileView: View {
    // MARK: - 1. Properties
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var username: String = ""
    @State private var petName: String = ""

    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""

    @State private var isSaving = false
    @State private var localError: String?

    // MARK: - 2. Body
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - 3. Profile Information
                Section(header: Text("Profile Information")) {
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    TextField("Pet Name", text: $petName)
                }

                // MARK: - 4. Password Section
                Section(header: Text("Security")) {
                    SecureField("New Password", text: $newPassword)
                    SecureField("Confirm Password", text: $confirmPassword)
                }

                // MARK: - 5. Error Message
                if let msg = (localError ?? authVM.errorMessage) {
                    Section {
                        Text(msg)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }

                // MARK: - 6. Save Button
                Section {
                    Button {
                        Task { await save() }
                    } label: {
                        Text(isSaving ? "Saving..." : "Save Changes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .disabled(isSaving)
                    .listRowBackground(isSaving ? Color.gray : Color.pennyPurple)
                }
            }
            .scrollContentBackground(.hidden)
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

    // MARK: - 8. Methods
    private func loadPetName() async {
        if let petName = await authVM.fetchPetName() {
            self.petName = petName
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

        if !trimmedUsername.isEmpty {
            await authVM.updateUsername(trimmedUsername)
        }

        if !trimmedPetName.isEmpty {
            await authVM.updatePetName(trimmedPetName)
        }

        if !newPassword.isEmpty {
            await authVM.updatePassword(newPassword)
        }

        if authVM.errorMessage == nil && localError == nil {
            dismiss()
        }
    }

}
