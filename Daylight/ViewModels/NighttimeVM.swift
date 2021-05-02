//
//  NighttimeVM.swift
//  Daylight
//
//  Created by Ben Farmer on 4/24/21.
//
import CoreLocation
import Solar

extension Nighttime{
    class ViewModel: ObservableObject{
        @Published var timeData = TimeData()
        @Published var locationData = LocationData()
        let calendar = Calendar.current
        
        func setup(locationData: LocationData){
            //current time at night
            self.timeData.currentTime = Date()
            //tomorrows sunrise
            self.timeData.sunrise = Solar(coordinate: locationData.coordinates)?.sunrise ?? Date()
            //previous days sunset
            self.timeData.sunset = Solar(for: Date().addingTimeInterval(-60*60*24), coordinate: locationData.coordinates)?.sunset ?? Date()
            self.locationData = locationData

            print("~NighttimeVM Setup: TimeData: \(timeData)")
            print("~NighttimeVM Setup: Location Data: \(locationData)")
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
            print("NighttimeVM: Total Nighttime = \(totalNighttime)")
            return totalNighttime
        }
        
        func getElapsedNighttimeInterval() -> Int{
            let currentTime = Date()
            let elapsedTime = getSecondsBetweenDates(from: self.timeData.sunset, to: currentTime)
            print("NighttimeVM: Elapsed Time = \(elapsedTime)")
            return elapsedTime
        }
        
        func getPercentNighttimeElapsed() -> Double{
            let percent = (Double(getElapsedNighttimeInterval()) / Double(getTotalNighttimeInterval())) * 100
            print("NighttimeVM: Percent = \(percent)")
            return percent
        }
        
        func getEndAngle() -> Double{
            let endAngle = -Double.pi * 0.5 + (2 * Double.pi * (getPercentNighttimeElapsed() / 100))
            print("NighttimeVM: endAngle = \(endAngle)")
            return endAngle
        }
        
    }
}

