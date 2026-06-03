//
//  WatchProfileView.swift
//  PennyPalsWatchOS Watch App
//
//  Created by Kelompok 8 on 03/06/26.
//

import SwiftUI

struct WatchProfileView: View {
    @EnvironmentObject var connectivity: IOSConnectivity

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {

                // --- Avatar ---
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "#FF8FB5"),
                                Color(hex: "#9B7CFF"),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .overlay(
                        Text(avatarInitials)
                            .font(.title3.bold())
                            .foregroundColor(.white)
                    )

                // --- Name & Email ---
                VStack(spacing: 2) {
                    Text(connectivity.username)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(connectivity.email)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                // --- Stats Grid ---
                HStack(spacing: 8) {
                    StatBadge(
                        icon: "bitcoinsign.circle.fill",
                        value: "\(connectivity.coins)",
                        label: "Coins",
                        color: Color(hex: "#9B7CFF")
                    )

                    StatBadge(
                        icon: "flame.fill",
                        value: "\(connectivity.streak)d",
                        label: "Streak",
                        color: Color(hex: "#FF8F50")
                    )
                }

                // --- Total Savings Card ---
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "wallet.pass.fill")
                            .font(.caption2)
                            .foregroundColor(Color(hex: "#9B7CFF"))
                        Text("Total Savings")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                    }

                    HStack {
                        Text("Rp \(connectivity.totalSavings.formattedWithDot)")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .padding(10)
                .background(
                    Color.white.opacity(0.1),
                    in: RoundedRectangle(cornerRadius: 12)
                )

                // --- Penalty Status ---
                HStack(spacing: 6) {
                    Image(systemName: penaltyIcon)
                        .font(.caption2)
                        .foregroundColor(penaltyColor)

                    Text(penaltyText)
                        .font(.caption2.weight(.medium))
                        .foregroundColor(penaltyColor)

                    Spacer()
                }
                .padding(10)
                .background(
                    penaltyColor.opacity(0.15),
                    in: RoundedRectangle(cornerRadius: 12)
                )

                // --- Connection Status ---
                if !connectivity.isConnected {
                    HStack(spacing: 4) {
                        Image(systemName: "iphone.slash")
                            .font(.caption2)
                        Text("Waiting for iPhone...")
                            .font(.caption2)
                    }
                    .foregroundColor(.orange)
                    .padding(.top, 4)
                }
            }
            .padding(.horizontal, 4)
        }
    }

    // MARK: - Computed Properties

    private var avatarInitials: String {
        String(connectivity.username.prefix(2)).uppercased()
    }

    private var penaltyIcon: String {
        if !connectivity.isSafeFromPenalty {
            return "xmark.shield.fill"
        }
        let hoursRemaining = Calendar.current.dateComponents(
            [.hour], from: Date(), to: connectivity.nextPenaltyCheck
        ).hour ?? 0
        if hoursRemaining <= 24 {
            return "exclamationmark.triangle.fill"
        }
        return "checkmark.shield.fill"
    }

    private var penaltyColor: Color {
        if !connectivity.isSafeFromPenalty { return .red }
        let hoursRemaining = Calendar.current.dateComponents(
            [.hour], from: Date(), to: connectivity.nextPenaltyCheck
        ).hour ?? 0
        if hoursRemaining <= 24 { return .orange }
        return .green
    }

    private var penaltyText: String {
        if !connectivity.isSafeFromPenalty { return "Penalty Active" }
        let hoursRemaining = Calendar.current.dateComponents(
            [.hour], from: Date(), to: connectivity.nextPenaltyCheck
        ).hour ?? 0
        if hoursRemaining <= 24 { return "Save soon!" }
        return "Safe ✓"
    }
}

// MARK: - Stat Badge Component

struct StatBadge: View {
    var icon: String
    var value: String
    var label: String
    var color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)

            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(.white)

            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            Color.white.opacity(0.1),
            in: RoundedRectangle(cornerRadius: 12)
        )
    }
}

// MARK: - Number Formatter Extension (Watch-compatible)

extension Int {
    var formattedWithDot: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
