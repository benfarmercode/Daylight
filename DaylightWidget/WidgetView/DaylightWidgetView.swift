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
