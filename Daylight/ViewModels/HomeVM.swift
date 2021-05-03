//
//  HomeVM.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//
import CoreLocation
import os.log

extension Home{
    class ViewModel: ObservableObject{
        let logger = Logger(subsystem: subsystem!, category: "HomeVM")
//        var locationManager = LocationManager()
        @Published var locationServiceComplete = false
        @Published var isDaytime = true

        
        func runLocationService(){
            logger.info("Location service started.")
            LocationManager.shared.getUserLocation{ [weak self] location in
//                guard let location = LocationManager.shared.locationData.location else{
//                    return
//                }
                self?.getLocationName()
            }
        }
        
        func getLocationName(){
            logger.info("Resolving location name.")
            LocationManager.shared.resolveLocationName(with: LocationManager.shared.locationData.location){[weak self]locationName in
//                guard self?.locationManager.locationData.locationName != nil else{
//                    print("~HomeVM: location name could not be resolved")
//                    return
//                }
                self?.logger.info("Location name resolved!")
                
                self?.logger.info("Checking isDaytime.")
                
                self?.checkIsDaytime()
                
                self?.logger.info("Is Daytime - \(self?.isDaytime ?? true)!")
                self?.locationServiceComplete = true
                self?.logger.info("Location service complete!")
            }
        }
        
        func checkIsDaytime(){
            
            //CHANGE HOUR SHIFT TO SIMULATE DIFFERENT TIMES
            //SET HOUR SHIFT TO 0 TO USE CURRENT TIME
            let hourShift = 0
            let timeShift = Double(60*60*hourShift)
            
            let currentTime = Date().addingTimeInterval(timeShift)
            let (sunrise, sunset) = NTSolar.sunRiseAndSet(forDate: Date().addingTimeInterval(timeShift), atLocation: LocationManager.shared.locationData.coordinates, inTimeZone: TimeZone.current) ?? (Date(), Date())
            
            self.logger.info("CurrentTime: \(currentTime)")
            self.logger.info("RiseTime: \(sunrise)")
            self.logger.info("SetTime: \(sunset)")
            
            let isBeforeSunrise = currentTime < sunrise
            self.logger.info("Before Sunrise: \(isBeforeSunrise)")
            
            let isSunsetOrAfter = currentTime >= sunset
            self.logger.info("Sunset Or After: \(isSunsetOrAfter)")

            let nighttime = isBeforeSunrise || isSunsetOrAfter
            self.isDaytime = !nighttime
        }
    }

}

