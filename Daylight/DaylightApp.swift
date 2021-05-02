//
//  DaylightApp.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//

import SwiftUI

@main
struct DaylightApp: App {
    var body: some Scene {
        let locationManager = LocationManager()
        WindowGroup {
            Home()
                .environmentObject(locationManager)
        }
    }
}
