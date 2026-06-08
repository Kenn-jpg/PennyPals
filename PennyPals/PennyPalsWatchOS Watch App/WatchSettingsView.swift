//
//  WatchSettingsView.swift
//  PennyPalsWatchOS Watch App
//
//  Created by Kelompok 8 on 03/06/26.
//

import SwiftUI

struct WatchSettingsView: View {
    @EnvironmentObject var connectivity: IOSConnectivity

    var body: some View {
        VStack(spacing: 8) {
            // MARK: - 1. Header
            HStack {
                Image(systemName: "photo.fill")
                    .font(.caption)
                    .foregroundColor(Color(hex: "#9B7CFF"))
                Text("Backgrounds")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#2A2440"))
                Spacer()
            }
            .padding(.horizontal, 4)

            if connectivity.ownedBackgrounds.isEmpty {
                Spacer()
                Text("No backgrounds owned.")
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#6B6580"))
                Text("Buy some in the iPhone app!")
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#6B6580"))
                Spacer()
            } else {
                // MARK: - 2. Theme List
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(connectivity.ownedBackgrounds, id: \.self) { bg in
                            let isSelected = connectivity.selectedBackgroundId == bg["id"]
                            let name = bg["name"] ?? "Unknown"
                            let colorHex = bg["colorHex"] ?? "#FFF1F6"
                            let spotsHex = bg["spotsHex"] ?? "#E8F4FF"

                            Button(action: {
                                if let id = bg["id"] {
                                    connectivity.equipBackground(id: id)
                                }
                            }) {
                                HStack {
                                    // MARK: - 3. Color Preview Circle
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color(hex: colorHex), Color(hex: spotsHex)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Circle().stroke(Color.black.opacity(0.1), lineWidth: 1)
                                        )

                                    Text(name)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(isSelected ? Color(hex: "#9B7CFF") : Color(hex: "#2A2440"))
                                        .minimumScaleFactor(0.8)
                                        .lineLimit(1)

                                    Spacer()

                                    if isSelected {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(Color(hex: "#9B7CFF"))
                                    } else {
                                        Circle()
                                            .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                            .frame(width: 16, height: 16)
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    isSelected ? Color.white.opacity(0.8) : Color.white.opacity(0.4),
                                    in: Capsule()
                                )
                                .overlay(
                                    Capsule()
                                        .stroke(isSelected ? Color(hex: "#9B7CFF").opacity(0.5) : Color.clear, lineWidth: 2)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
