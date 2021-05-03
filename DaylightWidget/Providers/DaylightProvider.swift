//
//  Provider.swift
//  Daylight
//
//  Created by Ben Farmer on 5/3/21.
//

import WidgetKit

struct DaylightProvider: TimelineProvider {
    private let placeholderEntry = DaylightEntry(date: Date(), isDaytime: true, endAngle: Double.pi * 0.5)
    //dummy entry when widget is loading the data
    func placeholder(in context: Context) -> DaylightEntry {
        return placeholderEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (DaylightEntry) -> ()) {
        completion(placeholderEntry)
    }

    //array of timeline entrys to update the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<DaylightEntry>) -> ()) {
        var entries: [DaylightEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        /* Reading the encoded data from your shared App Group container storage */
        let encodedData_isDaytime  = UserDefaults(suiteName: suiteName)!.object(forKey: "isDaytime") as? Data
        let encodedData_endAngle  = UserDefaults(suiteName: suiteName)!.object(forKey: "endAngle") as? Data

        /* Decoding it using JSONDecoder*/
        if let isDaytimeEncoded = encodedData_isDaytime {
            let isDaytimeDecoded = try? JSONDecoder().decode(Bool.self, from: isDaytimeEncoded)
            if let isDaytime = isDaytimeDecoded{
                
                if let endAngleEncoded = encodedData_endAngle{
                    let endAngleDecoded = try? JSONDecoder().decode(Double.self, from: endAngleEncoded)
                    if let endAngle = endAngleDecoded{
                        let currentDate = Date()
                        let entry = DaylightEntry(date: currentDate, isDaytime: isDaytime, endAngle: endAngle)
                        entries.append(entry)
                    }
                }
            }
        }
        let refreshDate = Calendar.current.date(byAdding: .second, value: 5, to: Date())!
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }
}
