//
//  DayInfoViewModel.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//
import SwiftUI
import CoreLocation
import os.log
import WidgetKit
//ERRORS occuring at 7:00PM central time, or 0:00 UTC when the date changes to the next day. must account for this error...
//

extension Daylight{
    class ViewModel: ObservableObject{
        //MARK: PUBLIC
        @Published var isDaytime: Bool = true
        @Published var showTimeRemaining: Bool = false
        @Published var showAnimatingView: Bool = false
        @Published var showOnboarding: Bool = false
        
        @Published var currentTime: String = ""
        @Published var sunrise: String = ""
        @Published var sunset: String = ""
        @Published var remainingTime: String = ""
        @Published var totalTime: String = ""
        
        @Published var endAngle: Double = Double.pi * 0.5

        let dayColors = DayColors()
        let nightColors = NightColors()
        
        func setup(){
            update()
            logger.info("View Model setup complete.")
        }
        
        func update(){
            checkIsDaytime()
            setTimeData()
            setTimeDataStrings()
            setEndAngle()
            logger.info("View Model updated.")
        }
        
        func reloadWidgets(){
            WidgetCenter.shared.reloadAllTimelines()
            logger.info("Daylight Widgets reloaded.")
        }
        
        func checkIsDaytime(){
            let timeShift = Double(60*60*globalHourShift)
            
            let currentTime = Date().addingTimeInterval(timeShift)
            let (sunrise, sunset) = NTSolar.sunRiseAndSet(forDate: Date().addingTimeInterval(timeShift), atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
            
            logger.info("CurrentTime: \(currentTime)")
            logger.info("RiseTime: \(sunrise)")
            logger.info("SetTime: \(sunset)")
            
            let isBeforeSunrise = currentTime < sunrise
            logger.info("Before Sunrise: \(isBeforeSunrise)")
            
            let isSunsetOrAfter = currentTime >= sunset
            logger.info("Sunset Or After: \(isSunsetOrAfter)")

            let nighttime = isBeforeSunrise || isSunsetOrAfter
            
            if firstIsDaytimeCheckComplete{
                withAnimation(Animation.linear(duration: 8)) {
                    isDaytime = !nighttime
                }
            }
            else {
                firstIsDaytimeCheckComplete = true
                isDaytime = !nighttime
            }
        }
        
        //MARK: PRIVATE
        private let logger = Logger(subsystem: subsystem!, category: "DaylightVM")
        private let calendar = Calendar.current
        private var timeData = TimeData()
        private var firstIsDaytimeCheckComplete = false
        
        private func setTimeData(){
            let timeShift = Double(60 * 60 * globalHourShift)
            timeData.currentTime = Date().addingTimeInterval(timeShift)
            
            if(isDaytime){
                (timeData.sunrise, timeData.sunset) = NTSolar.sunRiseAndSet(
                    forDate: timeData.currentTime,
                    atLocation: LocationManager.shared.locationData.coordinates,
                    inTimeZone: TimeZone.current
                ) ?? (Date(), Date())
                
                logger.info("Daylight TimeData.CurrentTime: \(self.timeData.currentTime)")
                logger.info("Daylight TimeData.Sunset: \(self.timeData.sunset)")
                logger.info("Daylight TimeData.Sunrise: \(self.timeData.sunrise)")
            }
            
            else{
                //check if before midnight or after midnight
                let isAfterMidnight: Bool
                let calendar = Calendar(identifier: .gregorian)
                if calendar.dateComponents([.hour], from: self.timeData.currentTime).hour ?? 0 < 12{
                    isAfterMidnight = true
                }
                else{
                    isAfterMidnight = false
                }
                
                //set the sunrise and sunset times accounting for the correct day due to change at midnight
                if isAfterMidnight{
                    //"todays" sunrise
                    (self.timeData.sunrise, _) = NTSolar.sunRiseAndSet(forDate: self.timeData.currentTime, atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
                    
                    //previous days sunset
                    (_, self.timeData.sunset) = NTSolar.sunRiseAndSet(forDate: self.timeData.currentTime.addingTimeInterval(-60*60*24), atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
                }
                else{ //is before midnight
                    //tomorrows sunrise
                    (self.timeData.sunrise, _) = NTSolar.sunRiseAndSet(forDate: self.timeData.currentTime.addingTimeInterval(60*60*24), atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
                    
                    //todays sunset
                    (_, self.timeData.sunset) = NTSolar.sunRiseAndSet(forDate: self.timeData.currentTime, atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
                }
                logger.info("Nighttime TimeData.CurrentTime: \(self.timeData.currentTime)")
                logger.info("Nighttime TimeData.Sunset: \(self.timeData.sunset)")
                logger.info("Nighttime TimeData.Sunrise: \(self.timeData.sunrise)")
            }
            
        }
        
        private func setTimeDataStrings(){
            self.currentTime = getTimeStringFromDate(timeData.currentTime)
            self.sunrise = getTimeStringFromDate(timeData.sunrise)
            self.sunset = getTimeStringFromDate(timeData.sunset)
        
            logger.info("CurrentTime: \(self.currentTime)")
            logger.info("Sunset: \(self.sunset)")
            logger.info("Sunrise: \(self.sunrise)")
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            
            let totalTime = getTotalTimeInterval()
            self.totalTime = formatter.string(from: TimeInterval(totalTime)) ?? ""
            
            let timeRemaining = getTotalTimeInterval() - getElapsedTimeInterval() + 60
            self.remainingTime = formatter.string(from: TimeInterval(timeRemaining)) ?? ""
            
            logger.info("Remaining Time = \(self.remainingTime)")
        }
        
        private func setEndAngle(){
            self.endAngle = (2 * Double.pi * (getPercentTimeElapsed() / 100)) - Double.pi * 0.5
            // prevent more than 1 rotation of end angle.
            // force endAngle = startAngle if first rotation complete.
            if self.endAngle > (3 * Double.pi / 2){
                self.endAngle = -Double.pi * 0.5
            }
            logger.info("EndAngle = \(self.endAngle)")
        }
        
        private func getTotalTimeInterval() -> Int{
            let totalTime: Int
            
            if (self.isDaytime){
                totalTime = getSecondsBetweenDates(from: self.timeData.sunrise, to: self.timeData.sunset)
            }
            
            else{
                totalTime = getSecondsBetweenDates(from: self.timeData.sunset, to: self.timeData.sunrise)
            }
            
            logger.info("Total Time = \(totalTime)")
            return totalTime
        }
        
        private func getElapsedTimeInterval() -> Int{
            var elapsedTime: Int
            
            if (self.isDaytime){
                elapsedTime = getSecondsBetweenDates(from: self.timeData.sunrise, to: self.timeData.currentTime)
               
                
                // replace sunrise/sunset with previous UTC day sunset if elapsedtime is negative
                // elapsed time is negative when UTC day reaches next day (0:00) as sunrise and sunset times move forward
                if elapsedTime < 0 {
                    logger.notice("Elapsed daylight negative!")
                    (self.timeData.sunrise, self.timeData.sunset) = NTSolar.sunRiseAndSet(forDate: Date().addingTimeInterval(-60*60*24), atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
                    elapsedTime = getSecondsBetweenDates(from: self.timeData.sunrise, to: self.timeData.currentTime)
                    logger.info("Updated Elapsed Daylight = \(elapsedTime)")
                }
            }
            
            else{
                elapsedTime = getSecondsBetweenDates(from: self.timeData.sunset, to: self.timeData.currentTime)
            }

            logger.info("Elapsed Time = \(elapsedTime)")
            return elapsedTime
        }
        
        private func getPercentTimeElapsed() -> Double{
            let percent = (Double(getElapsedTimeInterval()) / Double(getTotalTimeInterval())) * 100
            logger.info("Elapsed Time Percent = \(percent)")
            return percent
        }
        
        private func getTimeStringFromDate(_ dateObject: Date) -> String{
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: dateObject)
        }
        
        private func getSecondsBetweenDates(from earlierDate: Date, to laterDate: Date) -> Int{
            let components = calendar.dateComponents([.second],from: earlierDate, to: laterDate)
            return components.second ?? 0
        }
        
    }
}
