//
//  Shapes.swift
//  Daylight
//
//  Created by Ben Farmer on 5/2/21.
//

import SwiftUI

struct BackgroundGradient: View{
    let innerColor: Color
    let outerColor: Color
    @State var opacity = 0.0
    @State var endRadius: CGFloat = 0.0
    
    var isDaytime: Bool?
    
    let nightWidth = globalDeviceWidth * 0.75
    let dayWidth = globalDeviceWidth * 0.30
    
    var body: some View{
        RadialGradient(gradient: Gradient(colors: [innerColor, outerColor]), center: .center, startRadius: 2, endRadius: endRadius)
            .ignoresSafeArea()
            .onAppear{
                if isDaytime == nil{
                    endRadius = dayWidth
                }
                else{
                    if isDaytime!{
                        endRadius = dayWidth
                    }
                    else{
                        endRadius = nightWidth
                    }
                }
            }
    }
}

struct CircleFull: View{
    let radius: CGFloat
    let fillColor: Color
    let forWidget: Bool
    let widgetType: WidgetType?
    
    let widgetSizes = WidgetSizes()
    
    var body: some View{
        GeometryReader{ geometry in
            Path{path in
                
                if forWidget{
                    var x: Int
                    var y: Int
                    (x,y) = widgetSizes.getWidgetSize(widgetType: widgetType ?? .small)
                    path.move(to:
                                CGPoint(
                                    x: x / 2,
                                    y: y / 2
                                )
                    )
                    path.addArc(
                        center: CGPoint(
                            x: x / 2,
                            y: y / 2
                        ),
                        radius: radius,
                        startAngle: .init(radians: Double.pi * 2 - 0.0001),
                        endAngle: .init(radians: 0),
                        clockwise: true
                    )
                }
                else {
                    path.move(to:
                                CGPoint(
                                    x: geometry.size.width / 2,
                                    y: geometry.size.height / 2
                                )
                    )
                    
                    path.addArc(
                        center: CGPoint(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2 ),
                        radius: radius,
                        startAngle: .init(radians: Double.pi * 2 - 0.0001),
                        endAngle: .init(radians: 0),
                        clockwise: true
                    )
                }
                
            }
            .fill(fillColor)
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.1), radius: 20, x: -5, y: -5)
        }
    }
}

struct CircleSlice: View{
    let radius: CGFloat
    let endAngle: Double
    let fillColor: Color
    let whiteShadowOpacity: Double
    let forWidget: Bool
    let widgetType: WidgetType?
    
    let widgetSizes = WidgetSizes()
    
    var body: some View{
        GeometryReader{geometry in
            Path{path in
                
                if forWidget{
                    var x: Int
                    var y: Int
                    (x,y) = widgetSizes.getWidgetSize(widgetType: widgetType ?? .small)
                    path.move(to:
                                CGPoint(
                                    x: x / 2,
                                    y: y / 2
                                )
                    )
                    
                    path.addArc(
                        center: CGPoint(
                            x: x / 2,
                            y: y / 2 ),
                        radius: radius,
                        startAngle: .init(radians: -Double.pi / 2),
                        endAngle: .init(radians: endAngle),
                        clockwise: true
                    )
                }
                else{
                    path.move(to:
                                CGPoint(
                                    x: geometry.size.width / 2,
                                    y: geometry.size.height / 2
                                )
                    )
                    
                    path.addArc(
                        center: CGPoint(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2 ),
                        radius: radius,
                        startAngle: .init(radians: -Double.pi / 2),
                        endAngle: .init(radians: endAngle),
                        clockwise: true
                    )
                }
            }
            .fill(fillColor)
            .shadow(color: Color.black.opacity(0.1), radius: 40, x: 10, y: 10)
            .shadow(color: Color.white.opacity(whiteShadowOpacity), radius: 15, x: -5, y: -5)
        }
    }
}

