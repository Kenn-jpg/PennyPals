//
//  PennyPalsWidgetBundle.swift
//  PennyPalsWidget
//
//  Created by student on 03/06/26.
//

import WidgetKit
import SwiftUI

// MARK: - 1. Widget Bundle
@main
struct PennyPalsWidgetBundle: WidgetBundle {
    var body: some Widget {
        PennyPalsWidget()
        PennyPalsWidgetControl()
    }
}
