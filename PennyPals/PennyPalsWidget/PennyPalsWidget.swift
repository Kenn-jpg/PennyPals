//
//  PennyPalsWidget.swift
//  PennyPalsWidget
//
//  Created by student on 03/06/26.
//

import WidgetKit
import SwiftUI

// MARK: - 1. Provider

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), name: "Penny", level: 5, xp: 150, maxXP: 200, mood: "happy")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = getPetData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = getPetData()
        // Widget updates mostly triggered by the main app, but we set a 15-min fallback
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func getPetData() -> SimpleEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.com.MAD.PennyPals")
        let name = sharedDefaults?.string(forKey: "widgetPetName") ?? "Your Pet"
        let level = sharedDefaults?.integer(forKey: "widgetPetLevel") ?? 1
        let xp = sharedDefaults?.integer(forKey: "widgetPetXP") ?? 0
        let maxXP = sharedDefaults?.integer(forKey: "widgetPetMaxXP") ?? 200
        let mood = sharedDefaults?.string(forKey: "widgetPetMood") ?? "hungry"
        
        return SimpleEntry(date: Date(), name: name, level: level, xp: xp, maxXP: maxXP, mood: mood)
    }
}

// MARK: - 2. Timeline Entry

struct SimpleEntry: TimelineEntry {
    let date: Date
    let name: String
    let level: Int
    let xp: Int
    let maxXP: Int
    let mood: String
}

// MARK: - 3. Widget Entry View

struct PennyPalsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 8) {
            // MARK: - 5. Header Component
            HStack {
                Text(entry.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 42/255, green: 36/255, blue: 64/255))
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                
                Spacer()
                
                Text(moodEmoji(entry.mood))
                    .font(.system(size: 20))
            }
            
            // MARK: - 6. Level Badge
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(Color(red: 155/255, green: 124/255, blue: 255/255))
                Text("Level \(entry.level)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 42/255, green: 36/255, blue: 64/255))
                Spacer()
            }
            
            // MARK: - 7. XP Progress Bar
            VStack(spacing: 4) {
                HStack {
                    Text("XP")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(entry.xp) / \(entry.maxXP)")
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
                            .frame(width: max(0, min(CGFloat(entry.xp) / CGFloat(max(1, entry.maxXP)), 1.0)) * geo.size.width, height: 8)
                    }
                }
                .frame(height: 8)
            }
            
            Spacer(minLength: 0)
        }
        .widgetURL(URL(string: "pennypals://widget-tap"))
    }
    
    private func moodEmoji(_ mood: String) -> String {
        switch mood {
        case "happy": return "😊"
        case "sad": return "😢"
        case "hungry": return "🥺"
        case "angry": return "😡"
        case "surprised": return "😲"
        case "cry": return "😭"
        case "sleepy": return "😴"
        case "dizzy": return "😵"
        case "wink": return "😉"
        default: return "🐾"
        }
    }
}

// MARK: - 4. Widget Configuration

struct PennyPalsWidget: Widget {
    let kind: String = "PennyPalsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PennyPalsWidgetEntryView(entry: entry)
                    .containerBackground(Color(red: 255/255, green: 241/255, blue: 246/255), for: .widget)
            } else {
                PennyPalsWidgetEntryView(entry: entry)
                    .padding()
                    .background(Color(red: 255/255, green: 241/255, blue: 246/255))
            }
        }
        .configurationDisplayName("PennyPals Status")
        .description("Keep an eye on your pet's mood and level right from your Home Screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    PennyPalsWidget()
} timeline: {
    SimpleEntry(date: .now, name: "Kitty", level: 12, xp: 450, maxXP: 500, mood: "happy")
    SimpleEntry(date: .now, name: "Doggo", level: 1, xp: 0, maxXP: 200, mood: "hungry")
}
