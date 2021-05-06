//
//  Provider.swift
//  Daylight
//
//  Created by Ben Farmer on 5/3/21.
//

import WidgetKit

struct DaylightProvider: TimelineProvider {
    
    var homeViewModel = Home.ViewModel()
    var daylightViewModel = Daylight.ViewModel()
    var nighttimeViewModel = Nighttime.ViewModel()
    
    private let placeholderEntry = DaylightEntry(
        date: Date(),
        isDaytime: true,
        endAngle: Double.pi * 0.5,
        currentTime: "12:18 PM",
        sunrise: "6:40 AM",
        sunset: "8:08 PM"
    )
    
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
        
        var isDaytime = true
        var endAngle = Double.pi * 0.5
        var timeData = TimeData()
        var currentTime: String = ""
        var sunset: String = ""
        var sunrise:String = ""
        
        if !homeViewModel.locationServiceComplete{
            homeViewModel.runLocationService()
        }
        
        else{
            homeViewModel.checkIsDaytime()
            if homeViewModel.isDaytime{
                isDaytime = true
                daylightViewModel.updateTimeData()
                daylightViewModel.updateEndAngle()
                currentTime = daylightViewModel.getCurrentTimeString()
                sunrise = daylightViewModel.getSunriseString()
                sunset = daylightViewModel.getSunriseString()
                timeData = daylightViewModel.timeData
                endAngle = daylightViewModel.endAngle
                
            }
            else{
                isDaytime = false
                nighttimeViewModel.updateTimeData()
                nighttimeViewModel.updateEndAngle()
                currentTime = nighttimeViewModel.getCurrentTimeString()
                sunrise = nighttimeViewModel.getSunriseString()
                sunset = nighttimeViewModel.getSunriseString()
                timeData = nighttimeViewModel.timeData
                endAngle = nighttimeViewModel.endAngle
            }
            let currentDate = Date()
            
            let entry = DaylightEntry(
                date: currentDate,
                isDaytime: isDaytime,
                endAngle: endAngle,
                currentTime: currentTime,
                sunrise: sunrise,
                sunset: sunset
            )
            
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            
            completion(timeline)
        }
    }
}
