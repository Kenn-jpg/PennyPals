//
//  LoginView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

enum LoginMode { case login, register }

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    var onLoginSuccess: (Bool) -> Void

    @State private var mode: LoginMode = .login
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var animateLogo = false

    // Komputasi properti untuk mengecek apakah form sudah diisi dengan benar
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

                    // --- HEADER & LOGO ---
                    VStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 24,
                                style: .continuous
                            ).fill(Color.white).frame(width: 96, height: 96)
                                .shadow(
                                    color: Color(hex: "#FF96C8").opacity(0.35),
                                    radius: 24,
                                    y: 8
                                )

                            // MENGGUNAKAN ICON APP DARI ASSETS
                            Image("PennyPals")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 72, height: 72)
                                .clipShape(RoundedRectangle(cornerRadius: 16))  // Opsional: Membulatkan ujung icon jika aslinya kotak lancip
                        }
                        .padding(.bottom, 12).scaleEffect(animateLogo ? 1 : 0.8)
                        .opacity(animateLogo ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.5)) {
                                animateLogo = true
                            }
                        }

                        Text("PennyPals").font(
                            .system(size: 26, weight: .semibold)
                        ).tracking(-0.5).foregroundColor(.pennyText)
                        Text("Save money. Raise your pal.").font(
                            .system(size: 14)
                        ).foregroundColor(.pennySecondaryText)
                    }.padding(.top, 64).padding(.bottom, 24)

                    // --- TAB PICKER (LOG IN / SIGN UP) ---
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
                                Text(label).font(
                                    .system(size: 14, weight: .medium)
                                ).frame(maxWidth: .infinity).padding(
                                    .vertical,
                                    10
                                )
                                .background(
                                    isSelected ? Color.white : Color.clear
                                ).foregroundColor(
                                    isSelected
                                        ? .pennyText : .pennySecondaryText
                                )
                                .clipShape(Capsule()).shadow(
                                    color: isSelected
                                        ? Color.black.opacity(0.05)
                                        : Color.clear,
                                    radius: 2,
                                    y: 1
                                )
                            }
                        }
                    }.padding(4).background(Color.white.opacity(0.6)).clipShape(
                        Capsule()
                    ).padding(.bottom, 20)

                    // --- INPUT FIELDS ---
                    VStack(spacing: 12) {
                        if mode == .register {
                            TextField("Username", text: $username).padding(
                                .horizontal,
                                16
                            ).frame(height: 48).background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(
                                    color: .black.opacity(0.03),
                                    radius: 5,
                                    y: 2
                                ).transition(
                                    .move(edge: .top).combined(with: .opacity)
                                )
                                .accessibilityIdentifier("usernameTextField")  // ID untuk UI Test
                        }

                        TextField("Email", text: $email).keyboardType(
                            .emailAddress
                        ).autocapitalization(.none).padding(.horizontal, 16)
                            .frame(height: 48).background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(
                                color: .black.opacity(0.03),
                                radius: 5,
                                y: 2
                            )
                            .accessibilityIdentifier("emailTextField")  // ID untuk UI Test

                        SecureField("Password", text: $password).padding(
                            .horizontal,
                            16
                        ).frame(height: 48).background(Color.white).clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        ).shadow(color: .black.opacity(0.03), radius: 5, y: 2)
                            .accessibilityIdentifier("passwordSecureField")  // ID untuk UI Test
                    }

                    // --- SUBMIT BUTTON ---
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
                    .disabled(!isFormValid)  // Disable tombol jika form tidak valid
                    .opacity(isFormValid ? 1.0 : 0.5)  // Buat sedikit transparan jika disabled
                    .accessibilityIdentifier(
                        mode == .login
                            ? "loginSubmitButton" : "registerSubmitButton"
                    )  // ID untuk UI Test

                    Spacer(minLength: 40)
                }.padding(.horizontal, 24)
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
