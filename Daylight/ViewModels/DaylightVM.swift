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
        //MARK: PUBLIC
        @Published var currentTime = ""
        @Published var sunrise = ""
        @Published var sunset = ""
        @Published var remainingDaylight = ""
        @Published var endAngle = Double.pi * 0.5
        var totalDaylight = ""
        
        func setup(){
            update()
            logger.info("Daylight View Model setup complete.")
        }
        
        func update(){
            setTimeData()
            setTimeDataStrings()
            setEndAngle()
            logger.info("Daylight View Model updated.")
        }
        
        func reloadWidgets(){
            WidgetCenter.shared.reloadAllTimelines()
            logger.info("Daylight Widgets reloaded.")
        }
        
        //MARK: PRIVATE
        private let logger = Logger(subsystem: subsystem!, category: "DaylightVM")
        private let calendar = Calendar.current
        private var timeData = TimeData()
        
        private func setTimeData(){
            let timeShift = Double(60 * 60 * globalHourShift)
            
            self.timeData.currentTime = Date().addingTimeInterval(timeShift)
            (self.timeData.sunrise, self.timeData.sunset) = NTSolar.sunRiseAndSet(
                forDate: self.timeData.currentTime,
                atLocation: LocationManager.shared.locationData.coordinates,
                inTimeZone: TimeZone.current
            ) ?? (Date(), Date())
            
            
            logger.info("Daylight TimeData.CurrentTime: \(self.timeData.currentTime)")
            logger.info("Daylight TimeData.Sunset: \(self.timeData.sunset)")
            logger.info("Daylight TimeData.Sunrise: \(self.timeData.sunrise)")
        }
        
        private func setTimeDataStrings(){
            self.currentTime = getTimeStringFromDate(timeData.currentTime)
            self.sunrise = getTimeStringFromDate(timeData.sunrise)
            self.sunset = getTimeStringFromDate(timeData.sunset)
            
            logger.info("Daylight CurrentTime: \(self.currentTime)")
            logger.info("Daylight Sunset: \(self.sunset)")
            logger.info("Daylight Sunrise: \(self.sunrise)")
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            
            let totalTime = getTotalDaylightInterval()
            self.totalDaylight = formatter.string(from: TimeInterval(totalTime)) ?? ""
            
            let timeRemaining = getTotalDaylightInterval() - getElapsedDaylightInterval()
            self.remainingDaylight = formatter.string(from: TimeInterval(timeRemaining)) ?? ""
            
            logger.info("Remaining Daylight = \(self.remainingDaylight)")
        }
        
        private func setEndAngle(){
            self.endAngle = (2 * Double.pi * (getPercentDaylightElapsed() / 100)) - Double.pi * 0.5
            // prevent more than 1 rotation of end angle.
            // force endAngle = startAngle if first rotation complete.
            if self.endAngle > (3 * Double.pi / 2){
                self.endAngle = -Double.pi * 0.5
            }
            logger.info("Daylight EndAngle = \(self.endAngle)")
        }
        
        private func getTotalDaylightInterval() -> Int{
            let totalDaylight = getSecondsBetweenDates(from: self.timeData.sunrise, to: self.timeData.sunset)
            logger.info("Total Daylight = \(totalDaylight)")
            return totalDaylight
        }
        
        private func getElapsedDaylightInterval() -> Int{
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
        
        private func getPercentDaylightElapsed() -> Double{
            let percent = (Double(getElapsedDaylightInterval()) / Double(getTotalDaylightInterval())) * 100
            logger.info("Elapsed Daylight Percent = \(percent)")
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
