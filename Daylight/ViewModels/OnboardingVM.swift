//
//  OnboardingController.swift
//  Daylight
//
//  Created by Ben Farmer on 6/3/21.
//

import SwiftUI

extension Onboarding{
    class ViewModel: ObservableObject{
        //MARK: PUBLIC
        @Published var deviceIsLandscape = false
        @Published var selectedPage = 1
        @Published var progressValue: Float = 0.0
        let duration: Float = 5.0
        let interval: Float = 0.5
        var timer = Timer()
        
        @objc func fireTimer(){
            timer = Timer.scheduledTimer(timeInterval: Double(self.interval), target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
        @objc func updateTimer(){
            withAnimation(Animation.linear(duration: Double(self.interval))){
                self.progressValue += ( self.interval / self.duration)
            }
            
            print("progress \(self.progressValue)")
            if self.progressValue >= 1.0{
                incrementPageControl()
            }
        }
    
        func invalidateTimer(){
            timer.invalidate()
        }
        
        func incrementPageControl(){
            selectedPage+=1
            withAnimation(Animation.linear(duration: 0)){
                self.progressValue = 0.0
            }
        }
        
        func decrementPageControl(){
            selectedPage-=1
            if self.selectedPage < 1{
                self.selectedPage = 1
            }
            withAnimation(Animation.linear(duration: 0)){
                self.progressValue = 0.0
            }

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
