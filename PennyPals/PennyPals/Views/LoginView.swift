//
//  LoginView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

/// Menentukan mode layar autentikasi yang sedang aktif (masuk log atau pendaftaran akun baru).
enum LoginMode { case login, register }

/// Antarmuka utama (Entry Point) untuk proses autentikasi pengguna ke Firebase (Log In / Sign Up).
struct LoginView: View {

    @EnvironmentObject var authVM: AuthViewModel

    /// Closure yang dipanggil ketika proses autentikasi selesai dan berhasil.
    /// Mengirimkan boolean bernilai `true` apabila user baru saja terdaftar (register), dan `false` jika sekadar login.
    var onLoginSuccess: (Bool) -> Void

    @State private var mode: LoginMode = .login
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var animateLogo = false

    /// Properti terhitung yang memastikan bahwa seluruh data form yang dibutuhkan telah terisi penuh.
    var isFormValid: Bool {
        if mode == .login {
            return !email.isEmpty && !password.isEmpty
        } else {
            return !email.isEmpty && !password.isEmpty && !username.isEmpty
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // Bagian Header & Logo
                    VStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 24,
                                style: .continuous
                            )
                            .fill(Color.white)
                            .frame(width: 96, height: 96)
                            .shadow(
                                color: Color(hex: "#FF96C8").opacity(0.35),
                                radius: 24,
                                y: 8
                            )

                            Image("PennyPals")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 72, height: 72)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.bottom, 12)
                        .scaleEffect(animateLogo ? 1 : 0.8)
                        .opacity(animateLogo ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.5)) {
                                animateLogo = true
                            }
                        }

                        Text("PennyPals")
                            .font(.system(size: 26, weight: .semibold))
                            .tracking(-0.5)
                            .foregroundColor(.pennyText)

                        Text("Save money. Raise your pal.")
                            .font(.system(size: 14))
                            .foregroundColor(.pennySecondaryText)
                    }
                    .padding(.top, 64)
                    .padding(.bottom, 24)

                    // Tab Pemilih Log In / Sign Up
                    HStack(spacing: 0) {
                        ForEach(["Log In", "Sign Up"], id: \.self) { label in
                            let isSelected =
                                (mode == .login && label == "Log In")
                                || (mode == .register && label == "Sign Up")

                            Button(action: {
                                withAnimation(.spring()) {
                                    mode =
                                        label == "Log In" ? .login : .register
                                }
                            }) {
                                Text(label)
                                    .font(.system(size: 14, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        isSelected ? Color.white : Color.clear
                                    )
                                    .foregroundColor(
                                        isSelected
                                            ? .pennyText : .pennySecondaryText
                                    )
                                    .clipShape(Capsule())
                                    .shadow(
                                        color: isSelected
                                            ? Color.black.opacity(0.05)
                                            : Color.clear,
                                        radius: 2,
                                        y: 1
                                    )
                            }
                        }
                    }
                    .padding(4)
                    .background(Color.white.opacity(0.6))
                    .clipShape(Capsule())
                    .padding(.bottom, 20)

                    // Bagian Input Field
                    VStack(spacing: 12) {
                        if mode == .register {
                            TextField("Username", text: $username)
                                .padding(.horizontal, 16)
                                .frame(height: 48)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(
                                    color: .black.opacity(0.03),
                                    radius: 5,
                                    y: 2
                                )
                                .transition(
                                    .move(edge: .top).combined(with: .opacity)
                                )
                                .accessibilityIdentifier("usernameTextField")
                        }

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(.horizontal, 16)
                            .frame(height: 48)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(
                                color: .black.opacity(0.03),
                                radius: 5,
                                y: 2
                            )
                            .accessibilityIdentifier("emailTextField")

                        SecureField("Password", text: $password)
                            .padding(.horizontal, 16)
                            .frame(height: 48)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(
                                color: .black.opacity(0.03),
                                radius: 5,
                                y: 2
                            )
                            .accessibilityIdentifier("passwordSecureField")
                    }

                    // Tombol Submit Autentikasi
                    Button(action: {
                        Task {
                            if mode == .login {
                                await authVM.login(
                                    email: email,
                                    password: password
                                )
                                if authVM.isAuthenticated {
                                    onLoginSuccess(false)
                                }
                            } else {
                                await authVM.register(
                                    email: email,
                                    password: password,
                                    username: username
                                )
                                if authVM.isAuthenticated {
                                    onLoginSuccess(true)
                                }
                            }
                        }
                    }) {
                        Text(mode == .login ? "Log In" : "Create Account")
                    }
                    .buttonStyle(PennyPrimaryButtonStyle())
                    .padding(.top, 20)
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.5)
                    .accessibilityIdentifier(
                        mode == .login
                            ? "loginSubmitButton" : "registerSubmitButton"
                    )

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
            }
        }
        .background(Color.pennyBackground.ignoresSafeArea())
        .alert(
            isPresented: Binding<Bool>(
                get: { authVM.errorMessage != nil },
                set: { _ in authVM.errorMessage = nil }
            )
        ) {
            Alert(
                title: Text("Error"),
                message: Text(authVM.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
