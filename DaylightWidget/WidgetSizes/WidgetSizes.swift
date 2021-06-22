//
//  WidsetSizes.swift
//  Daylight
//
//  Created by Ben Farmer on 5/5/21.
//

import SwiftUI

enum WidgetType{
    case small
    case medium
    case large
}

struct WidgetSizes{
    func getWidgetSize(widgetType: WidgetType) -> (Int,Int){
        switch widgetType{
        case .small:
            switch UIScreen.main.bounds.size {
            //iphone
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
            //ipad
            case CGSize(width: 768, height: 1024):
                return(141, 141)
            case CGSize(width: 810, height: 1080):
                return(146, 146)
            case CGSize(width: 834, height: 1112):
                return(150, 150)
            case CGSize(width: 820, height: 1180):
                return(155, 155)
            case CGSize(width: 834, height: 1194):
                return(155, 155)
            case CGSize(width: 1024, height: 1366):
                return(170, 170)
            default:
                return (155, 155)
            }
            
        case .medium:
            switch UIScreen.main.bounds.size {
            //iphone
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
            //ipad
            case CGSize(width: 768, height: 1024):
                return(305, 141)
            case CGSize(width: 810, height: 1080):
                return(320, 146)
            case CGSize(width: 834, height: 1112):
                return(327, 150)
            case CGSize(width: 820, height: 1180):
                return(342, 155)
            case CGSize(width: 834, height: 1194):
                return(342, 155)
            case CGSize(width: 1024, height: 1366):
                return(378, 170)
            default:
                return (329, 155)
            }
            
        case .large:
            switch UIScreen.main.bounds.size {
            //iphone
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
            //ipad
            case CGSize(width: 768, height: 1024):
                return(305, 305)
            case CGSize(width: 810, height: 1080):
                return(320, 320)
            case CGSize(width: 834, height: 1112):
                return(327, 327)
            case CGSize(width: 820, height: 1180):
                return(342, 342)
            case CGSize(width: 834, height: 1194):
                return(342, 342)
            case CGSize(width: 1024, height: 1366):
                return(378, 378)
            default:
                return (329, 345)
            }
        }
    }
}
