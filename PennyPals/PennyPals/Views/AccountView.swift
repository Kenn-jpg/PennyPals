//
//  AccountScreen.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authVM: AuthViewModel
    var onLogout: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Account").font(.largeTitle.bold()).foregroundColor(
                        .pennyText
                    )
                    Spacer()
                }.padding(.horizontal).padding(.top, 20).padding(.bottom, 16)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Circle().fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "#FF8FB5"), .pennyPurple,
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            ).frame(width: 80, height: 80).overlay(
                                Text(
                                    String(
                                        authVM.currentUser?.username.prefix(2)
                                            ?? "JM"
                                    ).uppercased()
                                ).font(.title.bold()).foregroundColor(.white)
                            )
                            VStack(spacing: 4) {
                                Text(authVM.currentUser?.username ?? "User")
                                    .font(.title3.bold()).foregroundColor(
                                        .pennyText
                                    )
                                Text(
                                    authVM.currentUser?.email
                                        ?? "email@example.com"
                                ).font(.subheadline).foregroundColor(
                                    .pennySecondaryText
                                )
                            }
                            HStack(spacing: 20) {
                                VStack {
                                    Text("\(authVM.currentUser?.coins ?? 0)")
                                        .font(.headline).foregroundColor(
                                            .pennyPurple
                                        )
                                    Text("Coins").font(.caption)
                                        .foregroundColor(.pennySecondaryText)
                                }
                                Divider().frame(height: 30)
                                VStack {
                                    Text("\(authVM.currentUser?.streak ?? 0)d")
                                        .font(.headline).foregroundColor(
                                            .pennyPurple
                                        )
                                    Text("Streak").font(.caption)
                                        .foregroundColor(.pennySecondaryText)
                                }
                            }.padding(.top, 8)
                        }.frame(maxWidth: .infinity).padding().background(
                            Color(UIColor.systemBackground)
                        ).clipShape(RoundedRectangle(cornerRadius: 24)).shadow(
                            color: .black.opacity(0.04),
                            radius: 8,
                            y: 4
                        )

                        VStack(alignment: .leading, spacing: 8) {
                            Text("SETTINGS").font(.caption.weight(.semibold))
                                .foregroundColor(.pennySecondaryText).padding(
                                    .horizontal,
                                    8
                                )
                            VStack(spacing: 0) {
                                SettingRow(
                                    icon: "bell.fill",
                                    color: .blue,
                                    title: "Notifications"
                                )
                                Divider().padding(.leading, 56)
                                SettingRow(
                                    icon: "moon.fill",
                                    color: .indigo,
                                    title: "Theme"
                                )
                                Divider().padding(.leading, 56)
                                SettingRow(
                                    icon: "globe",
                                    color: .green,
                                    title: "Language"
                                )
                            }.background(Color(UIColor.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(
                                    color: .black.opacity(0.03),
                                    radius: 5,
                                    y: 2
                                )
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("SUPPORT").font(.caption.weight(.semibold))
                                .foregroundColor(.pennySecondaryText).padding(
                                    .horizontal,
                                    8
                                )
                            VStack(spacing: 0) {
                                SettingRow(
                                    icon: "questionmark.circle.fill",
                                    color: .orange,
                                    title: "Help Center"
                                )
                                Divider().padding(.leading, 56)
                                SettingRow(
                                    icon: "doc.text.fill",
                                    color: .gray,
                                    title: "Terms of Service"
                                )
                            }.background(Color(UIColor.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(
                                    color: .black.opacity(0.03),
                                    radius: 5,
                                    y: 2
                                )
                        }

                        Button(action: onLogout) {
                            Text("Log Out").font(.headline).foregroundColor(
                                .red
                            ).frame(maxWidth: .infinity, minHeight: 52)
                                .background(Color.red.opacity(0.1)).clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                        }.padding(.top, 12).padding(.bottom, 24)
                    }.padding(.horizontal)
                }
            }
            .background(Color.pennyBackground.ignoresSafeArea())
        }
    }
}

struct SettingRow: View {
    var icon: String
    var color: Color
    var title: String
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                ZStack {
                    Circle().fill(color.opacity(0.15)).frame(
                        width: 32,
                        height: 32
                    )
                    Image(systemName: icon).foregroundColor(color).font(
                        .system(size: 14, weight: .semibold)
                    )
                }
                Text(title).font(.system(size: 16, weight: .medium))
                    .foregroundColor(.pennyText)
                Spacer()
                Image(systemName: "chevron.right").font(
                    .system(size: 14, weight: .semibold)
                ).foregroundColor(Color(hex: "#D0C9E0"))
            }.padding(.horizontal, 16).padding(.vertical, 12).contentShape(
                Rectangle()
            )
        }.buttonStyle(.plain)
    }
}
