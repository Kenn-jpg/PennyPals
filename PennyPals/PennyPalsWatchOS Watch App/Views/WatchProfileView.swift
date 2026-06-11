//
//  WatchProfileView.swift
//  PennyPalsWatchOS Watch App
//

import SwiftUI

struct WatchProfileView: View {
    @EnvironmentObject var viewModel: WatchViewModel

    var body: some View {
        VStack(spacing: 4) {
            Spacer(minLength: 0)

            // MARK: - 1. Avatar
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
                .frame(width: 36, height: 36)
                .overlay(
                    Text(viewModel.avatarInitials)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 2, y: 1)

            // MARK: - 2. Name
            Text(viewModel.user.username)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(hex: "#2A2440"))
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer(minLength: 0)

            // MARK: - 3. Stats Grid
            HStack(spacing: 6) {
                StatBadge(
                    icon: "bitcoinsign.circle.fill",
                    value: "\(viewModel.user.coins)",
                    label: "Coins",
                    color: Color(hex: "#9B7CFF")
                )

                StatBadge(
                    icon: "flame.fill",
                    value: "\(viewModel.user.streak)d",
                    label: "Streak",
                    color: Color(hex: "#FF8F50")
                )
            }

            // MARK: - 4. Total Savings Card
            VStack(spacing: 0) {
                HStack(spacing: 4) {
                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 9))
                        .foregroundColor(Color(hex: "#9B7CFF"))
                    Text("Total Savings")
                        .font(.system(size: 9))
                        .foregroundColor(Color(hex: "#6B6580"))
                    Spacer()
                }

                HStack {
                    Text("Rp \(viewModel.user.totalSavings.formattedWithDot)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "#2A2440"))
                        .minimumScaleFactor(0.8)
                    Spacer()
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Color.white.opacity(0.6),
                in: RoundedRectangle(cornerRadius: 8)
            )

            // MARK: - 5. Penalty Status
            HStack(spacing: 4) {
                Image(systemName: viewModel.penaltyIcon)
                    .font(.system(size: 9))
                    .foregroundColor(viewModel.penaltyColor)

                Text(viewModel.penaltyText)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(viewModel.penaltyColor)

                Spacer()
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(
                Color.white.opacity(0.6),
                in: RoundedRectangle(cornerRadius: 6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(viewModel.penaltyColor.opacity(0.3), lineWidth: 1)
            )

            // MARK: - 6. Connection Status
            if !viewModel.isConnected {
                HStack(spacing: 4) {
                    Image(systemName: "iphone.slash")
                        .font(.system(size: 8))
                    Text("Waiting for iPhone...")
                        .font(.system(size: 8))
                }
                .foregroundColor(.orange)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Stat Badge Component
struct StatBadge: View {
    var icon: String
    var value: String
    var label: String
    var color: Color

    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(hex: "#2A2440"))

            Text(label)
                .font(.system(size: 9))
                .foregroundColor(Color(hex: "#6B6580"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .background(
            Color.white.opacity(0.6),
            in: RoundedRectangle(cornerRadius: 10)
        )
    }
}

// MARK: - Number Formatter Extension
extension Int {
    var formattedWithDot: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
