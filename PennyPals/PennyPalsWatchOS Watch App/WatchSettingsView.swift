//
//  WatchSettingsView.swift
//  PennyPalsWatchOS Watch App
//
//  Created by Kelompok 8 on 03/06/26.
//

import SwiftUI

// Pilihan tema background untuk Watch app
enum WatchTheme: String, CaseIterable, Identifiable {
    case midnight = "Midnight"
    case pennyPink = "Penny Pink"
    case ocean = "Ocean"
    case forest = "Forest"
    case sunset = "Sunset"
    case lavender = "Lavender"

    var id: String { rawValue }

    var gradient: LinearGradient {
        switch self {
        case .midnight:
            return LinearGradient(
                colors: [Color(hex: "#1A1A2E"), Color(hex: "#16213E")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .pennyPink:
            return LinearGradient(
                colors: [Color(hex: "#2D1B2E"), Color(hex: "#1A1228")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .ocean:
            return LinearGradient(
                colors: [Color(hex: "#0D2137"), Color(hex: "#0A3D62")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .forest:
            return LinearGradient(
                colors: [Color(hex: "#1B2A1B"), Color(hex: "#0D3320")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .sunset:
            return LinearGradient(
                colors: [Color(hex: "#2D1F0E"), Color(hex: "#3D1C11")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .lavender:
            return LinearGradient(
                colors: [Color(hex: "#1E1533"), Color(hex: "#2D1B4E")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }

    var accentColor: Color {
        switch self {
        case .midnight: return Color(hex: "#5DADE2")
        case .pennyPink: return Color(hex: "#FF8FB5")
        case .ocean: return Color(hex: "#48C9B0")
        case .forest: return Color(hex: "#82E0AA")
        case .sunset: return Color(hex: "#F5B041")
        case .lavender: return Color(hex: "#BB8FCE")
        }
    }

    var previewColors: [Color] {
        switch self {
        case .midnight: return [Color(hex: "#1A1A2E"), Color(hex: "#5DADE2")]
        case .pennyPink: return [Color(hex: "#2D1B2E"), Color(hex: "#FF8FB5")]
        case .ocean: return [Color(hex: "#0D2137"), Color(hex: "#48C9B0")]
        case .forest: return [Color(hex: "#1B2A1B"), Color(hex: "#82E0AA")]
        case .sunset: return [Color(hex: "#2D1F0E"), Color(hex: "#F5B041")]
        case .lavender: return [Color(hex: "#1E1533"), Color(hex: "#BB8FCE")]
        }
    }
}

struct WatchSettingsView: View {
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = WatchTheme.midnight.rawValue

    private var selectedTheme: WatchTheme {
        WatchTheme(rawValue: selectedThemeRaw) ?? .midnight
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // --- Header ---
                HStack {
                    Image(systemName: "paintbrush.fill")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#9B7CFF"))
                    Text("Theme")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }

                // --- Theme Grid ---
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 8),
                        GridItem(.flexible(), spacing: 8),
                    ],
                    spacing: 8
                ) {
                    ForEach(WatchTheme.allCases) { theme in
                        let isSelected = selectedThemeRaw == theme.rawValue

                        Button(action: {
                            withAnimation(.easeOut(duration: 0.2)) {
                                selectedThemeRaw = theme.rawValue
                            }
                        }) {
                            VStack(spacing: 6) {
                                // Color Preview Circle
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: theme.previewColors,
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 36, height: 36)

                                    if isSelected {
                                        Image(systemName: "checkmark")
                                            .font(.caption.bold())
                                            .foregroundColor(.white)
                                    }
                                }

                                Text(theme.rawValue)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(
                                        isSelected ? theme.accentColor : .secondary
                                    )
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                isSelected
                                    ? theme.accentColor.opacity(0.15)
                                    : Color.white.opacity(0.05),
                                in: RoundedRectangle(cornerRadius: 12)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        isSelected
                                            ? theme.accentColor.opacity(0.5)
                                            : Color.clear,
                                        lineWidth: 1.5
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                // --- Preview ---
                VStack(spacing: 6) {
                    Text("Preview")
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedTheme.gradient)
                        .frame(height: 50)
                        .overlay(
                            HStack {
                                Circle()
                                    .fill(selectedTheme.accentColor)
                                    .frame(width: 16, height: 16)
                                Text("PennyPals")
                                    .font(.caption2.bold())
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                        )
                }

                // --- Info ---
                Text("Theme applies to all Watch screens")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 4)
        }
    }
}
