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
    
    var body: some View{
        RadialGradient(gradient: Gradient(colors: [innerColor, outerColor]), center: .center, startRadius: 2, endRadius: 312)
            .ignoresSafeArea()
    }
}

struct CircleFull: View{
    let radius: CGFloat
    let fillColor: Color
    let forWidget: Bool
    let widgetType: WidgetType?
    
    let widgetConverter = WidgetConverter()

    var body: some View{
        Path{path in
            if forWidget{
                var x: Int
                var y: Int
                (x,y) = widgetConverter.getWidgetSize(widgetType: widgetType ?? .small)
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
                                x: UIScreen.main.bounds.width / 2,
                                y: UIScreen.main.bounds.height / 2
                            )
                )
                
                path.addArc(
                    center: CGPoint(
                        x: UIScreen.main.bounds.width / 2,
                        y: UIScreen.main.bounds.height / 2 ),
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
        //(sunshadow had white opacity of 0.1)
    }
}

struct CircleSlice: View{
    let radius: CGFloat
    let endAngle: Double
    let fillColor: Color
    let whiteShadowOpacity: Double
    let forWidget: Bool
    let widgetType: WidgetType?
    
    let widgetConverter = WidgetConverter()

    var body: some View{
        Path{path in
            if forWidget{
                var x: Int
                var y: Int
                (x,y) = widgetConverter.getWidgetSize(widgetType: widgetType ?? .small)
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
                                x: UIScreen.main.bounds.width / 2,
                                y: UIScreen.main.bounds.height / 2
                            )
                )
                
                path.addArc(
                    center: CGPoint(
                        x: UIScreen.main.bounds.width / 2,
                        y: UIScreen.main.bounds.height / 2 ),
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


struct WidgetConverter{
    func getWidgetSize(widgetType: WidgetType) -> (Int,Int){
        switch widgetType{
        case .small:
            switch UIScreen.main.bounds.size {
            case CGSize(width: 428, height: 926):
                return (170, 170)
            case CGSize(width: 414, height: 896):
                return (169, 169)
            case CGSize(width: 414, height: 736):
                return (159, 159)
            case CGSize(width: 390, height: 844):
                return (158, 158)
            case CGSize(width: 375, height: 812):
                return (155, 155)
            case CGSize(width: 375, height: 667):
                return (148, 148)
            case CGSize(width: 360, height: 780):
                return (155, 155)
            case CGSize(width: 320, height: 568):
                return (141, 141)
            default:
                return (155, 155)
            }
            
        case .medium:
            switch UIScreen.main.bounds.size {
            case CGSize(width: 428, height: 926):
                return (364, 170)
            case CGSize(width: 414, height: 896):
                return (360, 169)
            case CGSize(width: 414, height: 736):
                return (348, 159)
            case CGSize(width: 390, height: 844):
                return (338, 158)
            case CGSize(width: 375, height: 812):
                return (329, 155)
            case CGSize(width: 375, height: 667):
                return (321, 148)
            case CGSize(width: 360, height: 780):
                return (329, 155)
            case CGSize(width: 320, height: 568):
                return (292, 141)
            default:
                return (329, 155)
            }
            
        case .large:
            switch UIScreen.main.bounds.size {
            case CGSize(width: 428, height: 926):
                return (364, 382)
            case CGSize(width: 414, height: 896):
                return (360, 379)
            case CGSize(width: 414, height: 736):
                return (348, 357)
            case CGSize(width: 390, height: 844):
                return (338, 354)
            case CGSize(width: 375, height: 812):
                return (329, 345)
            case CGSize(width: 375, height: 667):
                return (321, 324)
            case CGSize(width: 360, height: 780):
                return (329, 345)
            case CGSize(width: 320, height: 568):
                return (292, 311)
            default:
                return (329, 345)
            }
            
        default:
            switch UIScreen.main.bounds.size {
            default:
                return (155, 155)
            }
        }
    }
}
