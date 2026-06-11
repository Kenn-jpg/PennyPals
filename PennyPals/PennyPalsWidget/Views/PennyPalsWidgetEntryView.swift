//
//  PennyPalsWidgetEntryView.swift
//  PennyPalsWidget
//

import SwiftUI
import WidgetKit

struct PennyPalsWidgetEntryView : View {
    var entry: PennyPalsWidgetEntry
    let viewModel = PennyPalsWidgetViewModel()

    var body: some View {
        VStack(spacing: 8) {
            // MARK: - Header Component
            HStack {
                Text(entry.pet.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 42/255, green: 36/255, blue: 64/255))
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                
                Spacer()
                
                Text(viewModel.moodEmoji(for: entry.pet.mood))
                    .font(.system(size: 20))
            }
            
            // MARK: - Level Badge
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(Color(red: 155/255, green: 124/255, blue: 255/255))
                Text("Level \(entry.pet.level)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 42/255, green: 36/255, blue: 64/255))
                Spacer()
            }
            
            // MARK: - XP Progress Bar
            VStack(spacing: 4) {
                HStack {
                    Text("XP")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(entry.pet.xp) / \(entry.pet.maxXP)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(red: 155/255, green: 124/255, blue: 255/255))
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(red: 42/255, green: 36/255, blue: 64/255).opacity(0.1))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 255/255, green: 143/255, blue: 181/255), Color(red: 155/255, green: 124/255, blue: 255/255)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: CGFloat(viewModel.xpProgressRatio(xp: entry.pet.xp, maxXP: entry.pet.maxXP)) * geo.size.width, height: 8)
                    }
                }
                .frame(height: 8)
            }
            
            Spacer(minLength: 0)
        }
        .widgetURL(URL(string: "pennypals://widget-tap"))
    }
}
