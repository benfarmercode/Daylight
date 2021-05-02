//
//  DayInfoViewModel.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//

import SwiftUI
import Solar
import CoreLocation

class TimeDataVM: ObservableObject{
    //Defaults - use setup to initialize onAppear
    @Published var dayInfo: TimeData?
//
//    init(){
//        sunrise = solar?.sunrise
//        sunset = solar?.sunset
//        startAngle = -Double.pi * 0.5
//        endAngle = -Double.pi * 0.5 + (2 * Double.pi * (getPercentDaylightElapsed() / 100))
//    }
    
//    func setup(coordinates: CLLocationCoordinate2D){
//        self.solar = Solar(coordinate: coordinates)
//        self.sunrise = solar?.sunrise
//        self.sunset = solar?.sunset
//        self.startAngle = -Double.pi * 0.5
//        self.endAngle = -Double.pi * 0.5 + (2 * Double.pi * (getPercentDaylightElapsed() / 100))
//    }
//
//    func getSunriseString() -> String {
//        return getTimeStringFromDate(self.sunrise ?? Date())
//    }
//
//    func getSunsetString() -> String{
//        return getTimeStringFromDate(self.sunset ?? Date())
//    }
//
//    func getCurrentTimeString() -> String{
//        return getTimeStringFromDate(Date())
//    }
//
//    func getTimeStringFromDate(_ dateObject: Date) -> String{
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        return formatter.string(from: dateObject)
//    }
//
//    func getSecondsBetweenDates(from earlierDate: Date, to laterDate: Date) -> Int{
//        let components = calendar.dateComponents([.second],from: earlierDate, to: laterDate)
//        return components.second ?? 0
//    }
//
//    func getTotalDaylightInterval() -> Int{
//        let sunrise = self.sunrise ?? Date()
//        let sunset = self.sunset ?? Date()
//        return getSecondsBetweenDates(from: sunrise, to: sunset)
//    }
//
//    func getElapsedDaylightInterval() -> Int{
//        let currentTime = Date()
//        let sunrise = self.sunrise ?? Date()
//        return getSecondsBetweenDates(from: sunrise, to: currentTime)
//    }
//
//    func getPercentDaylightElapsed() -> Double{
//        return (Double(getElapsedDaylightInterval()) / Double(getTotalDaylightInterval())) * 100
//    }
//
//    func calculateEndAngle(){
//        endAngle = -Double.pi * 0.5 + (2 * Double.pi * (getPercentDaylightElapsed() / 100))
//    }
}
