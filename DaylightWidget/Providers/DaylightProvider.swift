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
    
    
    private let placeholderEntry = DaylightEntry(date: Date(), isDaytime: true, endAngle: Double.pi * 0.5, timeData: TimeData())
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
        
        if !homeViewModel.locationServiceComplete{
            homeViewModel.runLocationService()
        }
        
        else{
            homeViewModel.checkIsDaytime()
            if homeViewModel.isDaytime{
                isDaytime = true
                daylightViewModel.updateTimeData()
                daylightViewModel.updateEndAngle()
                timeData = daylightViewModel.timeData
                endAngle = daylightViewModel.endAngle
                
            }
            else{
                isDaytime = false
                nighttimeViewModel.updateTimeData()
                nighttimeViewModel.updateEndAngle()
                timeData = nighttimeViewModel.timeData
                endAngle = nighttimeViewModel.endAngle
            }
            let currentDate = Date()
            for minuteOffset in 0..<5{
                let entryDate = Calendar.current.date(byAdding: .minute, value: 15 * minuteOffset, to: currentDate)!
                let entry = DaylightEntry(date: entryDate, isDaytime: isDaytime, endAngle: endAngle, timeData: timeData)
                entries.append(entry)
            }
            let timeline = Timeline(entries: entries, policy: .atEnd)
            
            completion(timeline)
        }
    }
}


////array of timeline entrys to update the widget
//func getTimeline(in context: Context, completion: @escaping (Timeline<DaylightEntry>) -> ()) {
//    var entries: [DaylightEntry] = []
//
//    /* Reading the encoded data from your shared App Group container storage */
//    var isDaytime = true
//    var endAngle = Double.pi * 0.5
//    var timeData = TimeData()
//
//    let isDaytimeEncoded  = UserDefaults(suiteName: suiteName)!.object(forKey: "isDaytime") as? Data
//    let endAngleEncoded  = UserDefaults(suiteName: suiteName)!.object(forKey: "endAngle") as? Data
//    let timeDataEncoded  = UserDefaults(suiteName: suiteName)!.object(forKey: "timeData") as? Data
//
//    if let isDaytimePlaceholder = isDaytimeEncoded{
//        let isDayTimeDecoded =  try? JSONDecoder().decode(Bool.self, from: isDaytimePlaceholder)
//        if isDayTimeDecoded != nil{
//            isDaytime = isDayTimeDecoded!
//        }
//        else{
//            isDaytime = true
//            print("isDaytime could not be decoded")
//        }
//    }
//
//    if let endAnglePlaceholder = endAngleEncoded{
//        let endAngleDecoded =  try? JSONDecoder().decode(Double.self, from: endAnglePlaceholder)
//        if endAngleDecoded != nil{
//            endAngle = endAngleDecoded!
//        }
//        else{
//            endAngle = Double.pi * 0.5
//            print("endAngle could not be decoded")
//        }
//    }
//
//    if let timeDataPlaceholder = timeDataEncoded{
//        let timeDataDecoded =  try? JSONDecoder().decode(TimeData.self, from: timeDataPlaceholder)
//        if timeDataDecoded != nil{
//            timeData = timeDataDecoded!
//        }
//        else{
//            timeData = TimeData()
//            print("timeData could not be decoded")
//        }
//    }
//
//    let currentDate = Date()
//    let entry = DaylightEntry(date: currentDate, isDaytime: isDaytime, endAngle: endAngle, timeData: timeData)
//    entries.append(entry)
//
//    let refreshDate = Calendar.current.date(byAdding: .second, value: 5, to: Date())!
//    let timeline = Timeline(entries: entries, policy: .after(refreshDate))
//    completion(timeline)
//}
