//
//  WidgetView.swift
//  Daylight
//
//  Created by Ben Farmer on 5/3/21.
//

import WidgetKit
import SwiftUI

//view
struct DaylightWidgetView : View {
    @Environment(\.widgetFamily) var family
    var entry: DaylightProvider.Entry

    var body: some View {
        
        switch family {
        case .systemSmall:
            WidgetSmall(entry: entry)
        case .systemMedium:
            WidgetMedium(entry: entry)
        case .systemLarge:
            WidgetLarge(entry: entry)
        default:
            WidgetSmall(entry: entry)
        }
    }
}

struct DaylightWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            DaylightWidgetView(
                entry: DaylightEntry(
                    date: Date(),
                    isDaytime: true,
                    endAngle: Double.pi * 0.5,
                    currentTime: "12:18 PM",
                    sunrise: "6:40 AM",
                    sunset: "8:08 PM"
                )
            ).previewContext(WidgetPreviewContext(family: .systemSmall))
            
            DaylightWidgetView(
                entry: DaylightEntry(
                    date: Date(),
                    isDaytime: false,
                    endAngle: Double.pi * 0.5,
                    currentTime: "12:18 PM",
                    sunrise: "6:40 AM",
                    sunset: "8:08 PM"
                )
            ).previewContext(WidgetPreviewContext(family: .systemSmall))
            
            DaylightWidgetView(
                entry: DaylightEntry(
                    date: Date(),
                    isDaytime: true,
                    endAngle: Double.pi * 0.5,
                    currentTime: "12:18 PM",
                    sunrise: "6:40 AM",
                    sunset: "8:08 PM"
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            DaylightWidgetView(
                entry: DaylightEntry(
                    date: Date(),
                    isDaytime: false,
                    endAngle: Double.pi * 0.5,
                    currentTime: "12:18 PM",
                    sunrise: "6:40 AM",
                    sunset: "8:08 PM"
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            DaylightWidgetView(
                entry: DaylightEntry(
                    date: Date(),
                    isDaytime: true,
                    endAngle: Double.pi * 0.5,
                    currentTime: "12:18 PM",
                    sunrise: "6:40 AM",
                    sunset: "8:08 PM"
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            
            DaylightWidgetView(
                entry: DaylightEntry(
                    date: Date(),
                    isDaytime: false,
                    endAngle: Double.pi * 0.5,
                    currentTime: "12:18 PM",
                    sunrise: "6:40 AM",
                    sunset: "8:08 PM"
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

