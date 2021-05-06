//
//  HomeVM.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//
import CoreLocation
import os.log
import SwiftUI
import WidgetKit

extension Home{
    class ViewModel: ObservableObject{
        //MARK: PUBLIC
        @Published var locationServiceComplete = false
        @Published var isDaytime = true
        
        func runLocationService(){
            logger.info("Location service started.")
            LocationManager.shared.getUserLocation{ [weak self] location in
                self?.getLocationName()
            }
        }
        
        func scheduleMinuteChangeTimer(){
            let calendar = Calendar(identifier: .gregorian)
            let currentSeconds = calendar.dateComponents([.second], from: Date()).second
            //schedule timer to trigger at the next minute change
            let _ = Timer.scheduledTimer(timeInterval: Double(60 - (currentSeconds ?? 0)), target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
        }
        
        func checkIsDaytime(){
            let timeShift = Double(60*60*globalHourShift)
            
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
            
            withAnimation(.linear(duration: 4)) {
                self.isDaytime = !nighttime
            }
        }
        
        //MARK: PRIVATE
        private let logger = Logger(subsystem: subsystem!, category: "HomeVM")
        
        private func getLocationName(){
            logger.info("Resolving location name.")
            LocationManager.shared.resolveLocationName(with: LocationManager.shared.locationData.location){[weak self]locationName in
                self?.logger.info("Location name resolved!")
                
                self?.logger.info("Checking isDaytime.")
                
                self?.checkIsDaytime()
                
                self?.logger.info("Is Daytime - \(self?.isDaytime ?? true)!")
                self?.locationServiceComplete = true
                self?.logger.info("Location service complete!")
            }
        }
        
        @objc private func fireTimer(){
            //schedule a repeating timer every 60 seconds to check if daytime or nighttime.
            let _ = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(checkIsDaytimeTimer), userInfo: nil, repeats: true)
            checkIsDaytime()
        }
        
        @objc private func checkIsDaytimeTimer(){
            checkIsDaytime()
        }
    }
}

