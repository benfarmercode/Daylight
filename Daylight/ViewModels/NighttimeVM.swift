//
//  NighttimeVM.swift
//  Daylight
//
//  Created by Ben Farmer on 4/24/21.
//
import CoreLocation
import os.log

extension Nighttime{
    class ViewModel: ObservableObject{
        let logger = Logger(subsystem: subsystem!, category: "NighttimeVM")
        @Published var timeData = TimeData()
        @Published var locationData = LocationData()
        let calendar = Calendar.current
        
        func setup(locationData: LocationData){
            
            //CHANGE HOUR SHIFT TO SIMULATE DIFFERENT TIMES
            //SET HOUR SHIFT TO 0 TO USE CURRENT TIME
            let hourShift = -0
            let timeShift = Double(60*60*hourShift)
            
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
                (self.timeData.sunrise, _) = NTSolar.sunRiseAndSet(forDate: Date().addingTimeInterval(timeShift), atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
                
                //previous days sunset
                (_, self.timeData.sunset) = NTSolar.sunRiseAndSet(forDate: Date().addingTimeInterval(-60*60*24 + timeShift), atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
            }
            else{ //is before midnight
                //tomorrows sunrise
                (self.timeData.sunrise, _) = NTSolar.sunRiseAndSet(forDate: Date().addingTimeInterval(60*60*24 + timeShift), atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
                
                //todays sunset
                (_, self.timeData.sunset) = NTSolar.sunRiseAndSet(forDate: Date().addingTimeInterval(timeShift), atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
            }
            
            self.locationData = locationData

            logger.info("Nighttime CurrentTime: \(self.timeData.currentTime)")
            logger.info("Nighttime Sunset: \(self.timeData.sunset)")
            logger.info("Nighttime Sunrise: \(self.timeData.sunrise)")
        }
        
        func getSunriseString() -> String {
            return getTimeStringFromDate(self.timeData.sunrise)
        }
    
        func getSunsetString() -> String{
            return getTimeStringFromDate(self.timeData.sunset)
        }
    
        func getCurrentTimeString() -> String{
            return getTimeStringFromDate(Date())
        }
    
        func getTimeStringFromDate(_ dateObject: Date) -> String{
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: dateObject)
        }
        
        func getSecondsBetweenDates(from earlierDate: Date, to laterDate: Date) -> Int{
            let components = calendar.dateComponents([.second],from: earlierDate, to: laterDate)
            return components.second ?? 0
        }
        
        func getTotalNighttimeInterval() -> Int{
            let totalNighttime = getSecondsBetweenDates(from: self.timeData.sunset, to: self.timeData.sunrise)
            logger.info("Total Nighttime = \(totalNighttime)")
            return totalNighttime
        }
        
        func getElapsedNighttimeInterval() -> Int{
            let currentTime = Date()
//            let currentTime = self.timeData.currentTime
            let elapsedTime = getSecondsBetweenDates(from: self.timeData.sunset, to: currentTime)
            logger.info("Elapsed Night Time = \(elapsedTime)")
            return elapsedTime
        }
        
        func getPercentNighttimeElapsed() -> Double{
            let percent = (Double(getElapsedNighttimeInterval()) / Double(getTotalNighttimeInterval())) * 100
            logger.info("Elapsed Night Percent = \(percent)")
            return percent
        }
        
        func getEndAngle() -> Double{
            let endAngle = -Double.pi * 0.5 + (2 * Double.pi * (getPercentNighttimeElapsed() / 100))
            logger.info("Night EndAngle = \(endAngle)")
            return endAngle
        }
        
    }
}

