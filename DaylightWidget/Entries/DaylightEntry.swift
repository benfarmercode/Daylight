//
//  Entry.swift
//  Daylight
//
//  Created by Ben Farmer on 5/3/21.
//

import WidgetKit

//holds information provided by the main app.
struct DaylightEntry: TimelineEntry {
    let date: Date
    let isDaytime: Bool
    let endAngle: Double
    let timeData: TimeData
}
