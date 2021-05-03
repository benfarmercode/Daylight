//
//  TimeData.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//

import Foundation

struct TimeData: Codable{
    var currentTime = Date()
    var sunrise = Date()
    var sunset = Date()
}
