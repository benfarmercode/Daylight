//
//  NighttimeVM.swift
//  Daylight
//
//  Created by Ben Farmer on 4/24/21.
//
import CoreLocation
import os.log
import WidgetKit

extension Nighttime{
    class ViewModel: ObservableObject{
        //MARK: PUBLIC
        @Published var currentTime = ""
        @Published var sunrise = ""
        @Published var sunset = ""
        @Published var remainingNighttime = ""
        @Published var endAngle = Double.pi * 0.5
        
        func setup(){
            update()
            logger.info("Nighttime View Model setup complete.")
        }
        
        func update(){
            setTimeData()
            setTimeDataStrings()
            setEndAngle()
            logger.info("Nighttime View Model updated.")
        }
        
        func reloadWidgets(){
            WidgetCenter.shared.reloadAllTimelines()
            logger.info("Nighttime Widgets reloaded.")
        }
        
        //MARK: PRIVATE
        private let logger = Logger(subsystem: subsystem!, category: "NighttimeVM")
        private let calendar = Calendar.current
        private var timeData = TimeData()
        
        private func setTimeData(){
            let timeShift = Double(60*60*globalHourShift)
            
            //current time at night
            self.timeData.currentTime = Date().addingTimeInterval(timeShift)
            
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
        
        private func setTimeDataStrings(){
            self.currentTime = getTimeStringFromDate(timeData.currentTime)
            self.sunrise = getTimeStringFromDate(timeData.sunrise)
            self.sunset = getTimeStringFromDate(timeData.sunset)
            
            logger.info("Nighttime CurrentTime: \(self.currentTime)")
            logger.info("Nighttime Sunset: \(self.sunset)")
            logger.info("Nighttime Sunrise: \(self.sunrise)")
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .positional
            
            let timeRemaining = getTotalNighttimeInterval() - getElapsedNighttimeInterval()
            self.remainingNighttime = formatter.string(from: TimeInterval(timeRemaining)) ?? ""
            logger.info("Remaining Nighttime = \(self.remainingNighttime)")
        }
        
        private func setEndAngle(){
            self.endAngle = -Double.pi * 0.5 + (2 * Double.pi * (getPercentNighttimeElapsed() / 100))
            logger.info("Night EndAngle = \(self.endAngle)")
        }
        
        private func getTotalNighttimeInterval() -> Int{
            let totalNighttime = getSecondsBetweenDates(from: self.timeData.sunset, to: self.timeData.sunrise)
            logger.info("Total Nighttime = \(totalNighttime)")
            return totalNighttime
        }
        
        private func getElapsedNighttimeInterval() -> Int{
            let elapsedTime = getSecondsBetweenDates(from: self.timeData.sunset, to: self.timeData.currentTime)
            logger.info("Elapsed Night Time = \(elapsedTime)")
            return elapsedTime
        }
        
        private func getPercentNighttimeElapsed() -> Double{
            let percent = (Double(getElapsedNighttimeInterval()) / Double(getTotalNighttimeInterval())) * 100
            logger.info("Elapsed Night Percent = \(percent)")
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

