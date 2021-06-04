//
//  OnboardingController.swift
//  Daylight
//
//  Created by Ben Farmer on 6/3/21.
//

import SwiftUI

extension Onboarding{
    class ViewModel: ObservableObject{
        @Published var deviceIsLandscape = false
        @Published var selectedPage = 1
        
        @objc func fireTimer(){
            //schedule a repeating timer every 60 seconds to check if daytime or nighttime.
//            let _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(incrementPageControlTimer), userInfo: nil, repeats: true)
        }
        
        @objc func incrementPageControlTimer(){
            incrementPageControl()
        }
        
        func incrementPageControl(){
            selectedPage+=1
        }
        
        func checkDeviceOrientation(){
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            
            print("width: \(width)")
            print("height: \(height)")
            
            if width > height{
                self.deviceIsLandscape = true
                print("width-greater")
            }
            else{
                self.deviceIsLandscape = false
                print("height-greater")
            }
        }
    }
}
