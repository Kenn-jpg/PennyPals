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
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - 3. Avatar Section
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.pennyPurple.opacity(0.6), Color.pennyPurple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .shadow(color: Color.pennyPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                        // Menampilkan inisial user (2 huruf pertama) di tengah lingkaran
                        Text(username.isEmpty ? "US" : String(username.prefix(2)).uppercased())
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 16)

                    // MARK: - 4. Profile Information Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("PERSONAL INFO")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.pennySecondaryText)
                            .padding(.leading, 16)
                        
                        VStack(spacing: 0) {
                            inputRow(icon: "person.fill", placeholder: "Username", text: $username)
                            
                            Divider().padding(.leading, 56)
                            
                            inputRow(icon: "pawprint.fill", placeholder: "Pet Name", text: $petName)
                        }
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
                    }

                    // MARK: - 5. Password Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SECURITY")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.pennySecondaryText)
                            .padding(.leading, 16)
                        
                        VStack(spacing: 0) {
                            inputRow(icon: "lock.fill", placeholder: "New Password", text: $newPassword, isSecure: true)
                            
                            Divider().padding(.leading, 56)
                            
                            inputRow(icon: "lock.rotation", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                        }
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
                    }

                    // MARK: - 6. Error Message & Button Group
                    VStack(spacing: 12) {
                        let currentError = localError ?? authVM.errorMessage
                        
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(currentError ?? " ")
                        }
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(currentError != nil ? 1 : 0)

                        // MARK: - 7. Save Button (Premium Gradient)
                        Button {
                            Task { await save() }
                        } label: {
                            Text(isSaving ? "Saving..." : "Save Changes")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 54)
                                .background(
                                    Group {
                                        if isSaving {
                                            Color.gray
                                        } else {
                                            LinearGradient(
                                                colors: [Color.pink.opacity(0.6), Color.pennyPurple],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        }
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: Color.pennyPurple.opacity(isSaving ? 0 : 0.3), radius: 10, x: 0, y: 5)
                        }
                        .disabled(isSaving)
                    }
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
            }
            .background(Color.pennyBackground.ignoresSafeArea())
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.pennyPurple)
                        .fontWeight(.medium)
                }
            }
            .onAppear {
                username = authVM.currentUser?.username ?? ""
                Task { await loadPetName() }
            }
        }
    }

    // MARK: - Reusable Input Row Component
    private func inputRow(icon: String, placeholder: String, text: Binding<String>, isSecure: Bool = false) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.pennyPurple.opacity(0.7))
                .frame(width: 24)
            
            if isSecure {
                SecureField(placeholder, text: text)
            } else {
                TextField(placeholder, text: text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 54)
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

#Preview {
    EditProfileView()
        //.environmentObject(AuthViewModel()) // Uncomment jika ingin di-preview dengan Mock VM
}
