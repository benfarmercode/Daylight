//
//  DayInfoViewModel.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//
import CoreLocation

//ERRORS occuring at 7:00PM central time, or 0:00 UTC when the date changes to the next day. must account for this error...
//

extension Daylight{
    class ViewModel: ObservableObject{
        @Published var timeData = TimeData()
        @Published var locationData = LocationData()
        let calendar = Calendar.current
        
        func setup(locationData: LocationData){
            self.timeData.currentTime = Date()
            (self.timeData.sunrise, self.timeData.sunset) = NTSolar.sunRiseAndSet(forDate: Date(), atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
            self.locationData = locationData

            print("~DaylightVM Setup: TimeData: \(timeData)")
            print("~DaylightVM Setup: Location Data: \(locationData)")
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
    
        func getTotalDaylightInterval() -> Int{
            let totalDaylight = getSecondsBetweenDates(from: self.timeData.sunrise, to: self.timeData.sunset)
            print("DaylightVM: Total Daylight = \(totalDaylight)")
            return totalDaylight
        }
    
        func getElapsedDaylightInterval() -> Int{
            let currentTime = Date()
            var elapsedTime = getSecondsBetweenDates(from: self.timeData.sunrise, to: currentTime)
            print("DaylightVM: Elapsed Time = \(elapsedTime)")
            
            // replace sunrise/sunset with previous UTC day sunset if elapsedtime is negative
            // elapsed time is negative when UTC day reaches next day (0:00) as sunrise and sunset times move forward
            if elapsedTime < 0 {
                (self.timeData.sunrise, self.timeData.sunset) = NTSolar.sunRiseAndSet(forDate: Date().addingTimeInterval(-60*60*24), atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
                elapsedTime = getSecondsBetweenDates(from: self.timeData.sunrise, to: currentTime)
                print("DaylightVM: Updated Elapsed Time = \(elapsedTime)")
            }
            return elapsedTime
        }
    
        func getPercentDaylightElapsed() -> Double{
            return (Double(getElapsedDaylightInterval()) / Double(getTotalDaylightInterval())) * 100
        }
    
        func getEndAngle() -> Double{
            var endAngle = (2 * Double.pi * (getPercentDaylightElapsed() / 100)) - Double.pi * 0.5
            
            // prevent more than 1 rotation of end angle.
            // force endAngle = startAngle if first rotation complete.
            if endAngle > (3 * Double.pi / 2){
                endAngle = -Double.pi * 0.5
            }
            print("DaylightVM: endAngle = \(endAngle)")
            return endAngle
        }
    }
}
