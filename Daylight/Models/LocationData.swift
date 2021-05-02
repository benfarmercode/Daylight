//
//  LocationModel.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//

import Foundation
import CoreLocation

struct LocationData{
    var location: CLLocation
    var locationName: String
    var coordinates: CLLocationCoordinate2D
    var timeZone: TimeZone?
    
    init(){
        self.location = CLLocation()
        self.locationName = ""
        self.coordinates = CLLocationCoordinate2D()
        self.timeZone = TimeZone(secondsFromGMT: 0)
    }
}
