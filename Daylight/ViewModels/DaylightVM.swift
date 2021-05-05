//
//  DayInfoViewModel.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//
import CoreLocation
import os.log
import WidgetKit
//ERRORS occuring at 7:00PM central time, or 0:00 UTC when the date changes to the next day. must account for this error...
//

extension Daylight{
    class ViewModel: ObservableObject{
        let logger = Logger(subsystem: subsystem!, category: "DaylightVM")
        let calendar = Calendar.current
        @Published var timeData = TimeData()
        @Published var endAngle = Double.pi * 0.5
        
        func setup(){
            updateTimeData()
            updateEndAngle()
            logger.info("Daylight CurrentTime: \(self.timeData.currentTime)")
            logger.info("Daylight Sunset: \(self.timeData.sunset)")
            logger.info("Daylight Sunrise: \(self.timeData.sunrise)")
        }
        
        func updateTimeData(){
            let timeShift = Double(60 * 60 * globalHourShift)
            
            self.timeData.currentTime = Date().addingTimeInterval(timeShift)
            (self.timeData.sunrise, self.timeData.sunset) = NTSolar.sunRiseAndSet(forDate: self.timeData.currentTime, atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
            
            _ = getEndAngle()
            
            /* APPGROUP */
            if let encode = try? JSONEncoder().encode(self.timeData) {
                UserDefaults(suiteName:suiteName)!.set(encode, forKey: "timeData")
                logger.info("TimeData stored to user defaults")
            } else {
                logger.notice("TimeData not stored to user defaults")
            }
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        func updateEndAngle(){
            self.endAngle = (2 * Double.pi * (getPercentDaylightElapsed() / 100)) - Double.pi * 0.5
            
            // prevent more than 1 rotation of end angle.
            // force endAngle = startAngle if first rotation complete.
            if self.endAngle > (3 * Double.pi / 2){
                self.endAngle = -Double.pi * 0.5
            }
            logger.info("Daylight EndAngle = \(self.endAngle)")
        }
    
        func getSunriseString() -> String {
            return getTimeStringFromDate(self.timeData.sunrise)
        }
    
        func getSunsetString() -> String{
            return getTimeStringFromDate(self.timeData.sunset)
        }
    
        func getCurrentTimeString() -> String{
            return getTimeStringFromDate(self.timeData.currentTime)
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
    
        func getTotalDaylightInterval() -> Int{
            let totalDaylight = getSecondsBetweenDates(from: self.timeData.sunrise, to: self.timeData.sunset)
            logger.info("Total Daylight = \(totalDaylight)")
            return totalDaylight
        }
    
        func getElapsedDaylightInterval() -> Int{
            var elapsedTime = getSecondsBetweenDates(from: self.timeData.sunrise, to: self.timeData.currentTime)
            logger.info("Elapsed Daylight = \(elapsedTime)")
            
            // replace sunrise/sunset with previous UTC day sunset if elapsedtime is negative
            // elapsed time is negative when UTC day reaches next day (0:00) as sunrise and sunset times move forward
            if elapsedTime < 0 {
                logger.notice("Elapsed daylight negative!")
                (self.timeData.sunrise, self.timeData.sunset) = NTSolar.sunRiseAndSet(forDate: Date().addingTimeInterval(-60*60*24), atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
                elapsedTime = getSecondsBetweenDates(from: self.timeData.sunrise, to: self.timeData.currentTime)
                logger.info("Updated Elapsed Daylight = \(elapsedTime)")
            }
            return elapsedTime
        }
    
        func getPercentDaylightElapsed() -> Double{
            let percent = (Double(getElapsedDaylightInterval()) / Double(getTotalDaylightInterval())) * 100
            logger.info("Elapsed Daylight Percent = \(percent)")
            return percent
        }
    
        func getEndAngle() -> Double{
            var endAngle = (2 * Double.pi * (getPercentDaylightElapsed() / 100)) - Double.pi * 0.5
            
            // prevent more than 1 rotation of end angle.
            // force endAngle = startAngle if first rotation complete.
            if endAngle > (3 * Double.pi / 2){
                endAngle = -Double.pi * 0.5
            }
            logger.info("Daylight EndAngle = \(endAngle)")
            
            /* APPGROUP */
            if let encode = try? JSONEncoder().encode(endAngle) {
                UserDefaults(suiteName:suiteName)!.set(encode, forKey: "endAngle")
            } else {
                logger.notice("EndAngle not stored to user defaults")
            }
            
            /*  */
            
            return endAngle
        }
        
        func reloadWidgets(){
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
