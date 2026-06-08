//
//  PennyPalsWidgetBundle.swift
//  PennyPalsWidget
//
//  Created by student on 03/06/26.
//

import WidgetKit
import SwiftUI

/// Entry point atau titik awal untuk keseluruhan Widget Extension.
/// Bundle ini bisa memuat lebih dari satu jenis widget jika diperlukan ke depannya.
@main
struct PennyPalsWidgetBundle: WidgetBundle {
    var body: some Widget {
        PennyPalsWidget()
        PennyPalsWidgetControl()
    }
}
