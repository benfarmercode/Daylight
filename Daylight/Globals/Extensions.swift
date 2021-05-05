//
//  Extensions.swift
//  Daylight
//
//  Created by Ben Farmer on 5/3/21.
//

import SwiftUI

extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation(_ value: Bool) {
        appendInterpolation(String(value))
    }
}
