//
//  Shapes.swift
//  Daylight
//
//  Created by Ben Farmer on 5/2/21.
//

import SwiftUI

struct CircleFull: View{
    let fillColor: Color
    
    var body: some View{
        Path{path in
            path.move(to:
                        CGPoint(
                            x: UIScreen.main.bounds.width / 2,
                            y: UIScreen.main.bounds.height / 2
                        )
            )
            
            path.addArc(
                center: CGPoint(
                    x: UIScreen.main.bounds.width / 2,
                    y: UIScreen.main.bounds.height / 2 ),
                radius: 128,
                startAngle: .init(radians: Double.pi * 2 - 0.0001),
                endAngle: .init(radians: 0),
                clockwise: true
            )
        }
        .fill(fillColor)
        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 10, y: 10)
        .shadow(color: Color.white.opacity(0.1), radius: 20, x: -5, y: -5)
        //(sunshadow had white opacity of 0.1)
    }
}

struct CircleSlice: View{
    let endAngle: Double
    let fillColor: Color
    let whiteShadowOpacity: Double

    var body: some View{
        Path{path in
            path.move(to:
                        CGPoint(
                            x: UIScreen.main.bounds.width / 2,
                            y: UIScreen.main.bounds.height / 2
                        )
            )
            
            path.addArc(
                center: CGPoint(
                    x: UIScreen.main.bounds.width / 2,
                    y: UIScreen.main.bounds.height / 2 ),
                radius: 128,
                startAngle: .init(radians: -Double.pi / 2),
                endAngle: .init(radians: endAngle),
                clockwise: true
            )
        }
        .fill(fillColor)
        .shadow(color: Color.black.opacity(0.1), radius: 40, x: 10, y: 10)
        .shadow(color: Color.white.opacity(whiteShadowOpacity), radius: 15, x: -5, y: -5)
    }
}
