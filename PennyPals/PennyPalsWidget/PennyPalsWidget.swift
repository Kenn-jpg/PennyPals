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
    let viewModel = PennyPalsWidgetViewModel()

    func placeholder(in context: Context) -> PennyPalsWidgetEntry {
        PennyPalsWidgetEntry(
            date: Date(),
            pet: WidgetPetModel(name: "Penny", level: 5, xp: 150, maxXP: 200, mood: "happy")
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (PennyPalsWidgetEntry) -> ()) {
        let entry = PennyPalsWidgetEntry(date: Date(), pet: viewModel.fetchPetData())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PennyPalsWidgetEntry>) -> ()) {
        let entry = PennyPalsWidgetEntry(date: Date(), pet: viewModel.fetchPetData())
        // Widget updates mostly triggered by the main app, but we set a 15-min fallback
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - 2. Widget Configuration

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
    PennyPalsWidgetEntry(date: .now, pet: WidgetPetModel(name: "Kitty", level: 12, xp: 450, maxXP: 500, mood: "happy"))
    PennyPalsWidgetEntry(date: .now, pet: WidgetPetModel(name: "Doggo", level: 1, xp: 0, maxXP: 200, mood: "hungry"))
}
