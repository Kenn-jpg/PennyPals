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
            // --- Header ---
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
                // --- Theme List ---
                List {
                    ForEach(connectivity.ownedBackgrounds, id: \.self) { bg in
                        let isSelected = connectivity.selectedBackgroundId == bg["id"]
                        let name = bg["name"] ?? "Unknown"
                        let colorHex = bg["colorHex"] ?? "#1A1A2E"
                        let spotsHex = bg["spotsHex"] ?? "#16213E"

                        Button(action: {
                            if let id = bg["id"] {
                                connectivity.equipBackground(id: id)
                            }
                        }) {
                            HStack {
                                // Color Preview Circle
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
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(isSelected ? Color(hex: "#9B7CFF") : Color(hex: "#2A2440"))

                                Spacer()

                                if isSelected {
                                    Image(systemName: "checkmark")
                                        .font(.caption.bold())
                                        .foregroundColor(Color(hex: "#9B7CFF"))
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(isSelected ? Color.white.opacity(0.8) : Color.white.opacity(0.4))
                    }
                }
                .listStyle(.carousel)
            }
        }
    }
}
