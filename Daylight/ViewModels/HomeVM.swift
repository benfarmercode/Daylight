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
import UIKit

extension Home{
    class ViewModel: ObservableObject{
        //MARK: PUBLIC
        @Published var locationServiceComplete: Bool = false
        @Published var isDaytime: Bool = true
        @Published var viewAppeared: Bool = false
        @Published var showOnboarding: Bool = false
        
        init(){
            let screenSize = UIScreen.main.bounds
            let screenWidth = Int(screenSize.width)
            let screenHeight = Int(screenSize.height)
            
            let modelName = UIDevice.modelName
            
            logger.info("Model Name: \(modelName)")
            logger.info("Screen Width: \(screenWidth)")
            logger.info("Screen Height: \(screenHeight)")
        }
        
        func onLoad(){
            DispatchQueue.main.async { [weak self] in
                let didLaunchBefore = UserDefaults.standard.bool(forKey: "didLaunchBefore")
                if didLaunchBefore{
                    self?.runLocationService()
                    withAnimation(Animation.linear.delay(2)){
                        self?.viewAppeared = true
                    }
                }
                else{
                    UserDefaults.standard.set(true, forKey: "didLaunchBefore")
                    self?.showOnboarding = true
                }
            }
        }
        
        func dismissOnboardingSheet(){
            runLocationService()
            withAnimation(Animation.linear.delay(2)){
                viewAppeared = true
            }
        }
        
        func runLocationService(){
            logger.info("Location service started.")
            LocationManager.shared.getUserLocation{ [weak self] location in
                self?.getLocationName()
            }
        }

        //MARK: PRIVATE
        private let logger = Logger(subsystem: subsystem!, category: "HomeVM")
        
        private func getLocationName(){
            logger.info("Resolving location name.")
            LocationManager.shared.resolveLocationName(with: LocationManager.shared.locationData.location){[weak self]locationName in
                self?.logger.info("Location name resolved!")
                
                self?.logger.info("Checking isDaytime.")
                
                self?.logger.info("Is Daytime - \(self?.isDaytime ?? true)!")
                self?.locationServiceComplete = true
                self?.logger.info("Location service complete!")
            }
        }
    }
}
