//
//  DaylightWidget.swift
//  DaylightWidget
//
//  Created by Ben Farmer on 5/3/21.
//

import WidgetKit
import SwiftUI

//configuration
@main
struct DaylightWidget: Widget {
    let kind: String = "DaylightWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: DaylightProvider(),
            content: {DaylightWidgetView(entry: $0)}
        )
        .configurationDisplayName("Daylight Widget")
        .description("View the remaining daylight or night.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
