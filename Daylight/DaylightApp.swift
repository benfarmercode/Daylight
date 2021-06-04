//
//  DaylightApp.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//

import SwiftUI

@main
struct DaylightApp: App {
    
    init(){
        //LAUNCH
        let screenSize = UIScreen.main.bounds
        let screenWidth = Int(screenSize.width)
        let screenHeight = Int(screenSize.height)
        
        globalDeviceWidth = CGFloat(screenWidth)
        globalDeviceHeight = CGFloat(screenHeight)
    }

    var body: some Scene {
        WindowGroup {
            Home()
        }
    }
}

