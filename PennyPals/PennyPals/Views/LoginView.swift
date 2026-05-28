//
//  LoginScreen.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

enum LoginMode {
    case login, register
}

struct LoginView: View {
    var onLogin: () -> Void

    @State private var mode: LoginMode = .login
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""

    // Animasi logo (menggantikan framer-motion)
    @State private var animateLogo = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: - Header & Logo
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
                                x: 0,
                                y: 8
                            )

                            // Menggunakan PetView yang sudah ada di folder Components
                            PetView(mood: "happy", size: 72)
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
                            .font(
                                .system(
                                    size: 26,
                                    weight: .semibold,
                                    design: .default
                                )
                            )
                            .tracking(-0.5)  // tracking-tight
                            .foregroundColor(.pennyText)

                        Text("Save money. Raise your pal.")
                            .font(.system(size: 14))
                            .foregroundColor(.pennySecondaryText)
                    }
                    .padding(.top, 64)
                    .padding(.bottom, 24)

                    // MARK: - Toggle Login / Sign Up
                    HStack(spacing: 0) {
                        ForEach(["Log In", "Sign Up"], id: \.self) { label in
                            let isSelected =
                                (mode == .login && label == "Log In")
                                || (mode == .register && label == "Sign Up")

                            Button(action: {
                                withAnimation(
                                    .spring(response: 0.3, dampingFraction: 0.7)
                                ) {
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

                    // MARK: - Input Fields
                    VStack(spacing: 12) {
                        if mode == .register {
                            TextField("Username", text: $username)
                                .padding(.horizontal, 16)
                                .frame(height: 48)
                                .background(Color.white)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 16,
                                        style: .continuous
                                    )
                                )
                                .shadow(
                                    color: Color.black.opacity(0.03),
                                    radius: 5,
                                    y: 2
                                )
                                .transition(
                                    .move(edge: .top).combined(with: .opacity)
                                )
                        }

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(.horizontal, 16)
                            .frame(height: 48)
                            .background(Color.white)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 16,
                                    style: .continuous
                                )
                            )
                            .shadow(
                                color: Color.black.opacity(0.03),
                                radius: 5,
                                y: 2
                            )

                        SecureField("Password", text: $password)
                            .padding(.horizontal, 16)
                            .frame(height: 48)
                            .background(Color.white)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 16,
                                    style: .continuous
                                )
                            )
                            .shadow(
                                color: Color.black.opacity(0.03),
                                radius: 5,
                                y: 2
                            )
                    }

                    // Forgot Password
                    if mode == .login {
                        HStack {
                            Spacer()
                            Button("Forgot password?") {
                                // Aksi lupa password
                            }
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.pennyPurple)
                        }
                        .padding(.top, 8)
                    }

                    // MARK: - Action Button
                    Button(action: onLogin) {
                        Text(mode == .login ? "Log In" : "Create Account")
                    }
                    .buttonStyle(PennyPrimaryButtonStyle())
                    .padding(.top, 20)

                    // MARK: - Social Login Divider
                    HStack(spacing: 12) {
                        Rectangle().fill(Color(hex: "#E0DAF0")).frame(height: 1)
                        Text("or continue with")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#9B93B5"))
                        Rectangle().fill(Color(hex: "#E0DAF0")).frame(height: 1)
                    }
                    .padding(.vertical, 20)

                    // MARK: - Social Login Buttons
                    HStack(spacing: 12) {
                        // Apple
                        Button(action: {}) {
                            Image(systemName: "applelogo")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.white)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 16,
                                        style: .continuous
                                    )
                                )
                                .shadow(
                                    color: Color.black.opacity(0.03),
                                    radius: 5,
                                    y: 2
                                )
                        }

                        // Google (menggunakan SF Symbol envelope.fill mengikuti ikon Mail di React)
                        Button(action: {}) {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "#EA4335"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.white)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 16,
                                        style: .continuous
                                    )
                                )
                                .shadow(
                                    color: Color.black.opacity(0.03),
                                    radius: 5,
                                    y: 2
                                )
                        }

                        // Meta (Facebook)
                        Button(action: {}) {
                            Text("f")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color(hex: "#1877F2"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.white)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 16,
                                        style: .continuous
                                    )
                                )
                                .shadow(
                                    color: Color.black.opacity(0.03),
                                    radius: 5,
                                    y: 2
                                )
                        }
                    }

                    Spacer(minLength: 40)

                    // Footer
                    Text("By continuing you agree to our Terms & Privacy")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#9B93B5"))
                        .padding(.bottom, 24)
                }
                .padding(.horizontal, 24)
            }
        }
        .background(Color.pennyBackground.ignoresSafeArea())
    }
}

#Preview {
    LoginView(onLogin: {})
}
