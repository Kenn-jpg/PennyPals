//
//  WatchSettingsView.swift
//  PennyPalsWatchOS Watch App
//

import SwiftUI

struct WatchSettingsView: View {
    @EnvironmentObject var viewModel: WatchViewModel

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

            if viewModel.theme.ownedBackgrounds.isEmpty {
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
                        ForEach(viewModel.theme.ownedBackgrounds, id: \.self) { bg in
                            let isSelected = viewModel.theme.selectedBackgroundId == bg["id"]
                            let name = bg["name"] ?? "Unknown"
                            let colorHex = bg["colorHex"] ?? "#FFF1F6"
                            let spotsHex = bg["spotsHex"] ?? "#E8F4FF"

                            Button(action: {
                                if let id = bg["id"] {
                                    viewModel.equipBackground(id: id)
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

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
