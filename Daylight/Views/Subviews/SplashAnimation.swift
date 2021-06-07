//
//  SplashAnimation.swift
//  Daylight
//
//  Created by Ben Farmer on 6/4/21.
//

import SwiftUI

import SwiftUI



struct SplashView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SplashAnimation_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

struct SplashShape: Shape {
    
    public enum SplashAnimation {
        case leftToRight
        case rightToLeft
    }
    
    var progress: CGFloat
    var animationType: SplashAnimation
    
    var animatableData: CGFloat {
        get { return progress }
        set { self.progress = newValue}
    }

    
    func path(in rect: CGRect) -> Path {
       switch animationType {
           case .leftToRight:
               return leftToRight(rect: rect)
           case .rightToLeft:
               return rightToLeft(rect: rect)
       }
    }
    
    func leftToRight(rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0)) // Top Left
        path.addLine(to: CGPoint(x: rect.width * progress, y: 0)) // Top Right
        path.addLine(to: CGPoint(x: rect.width * progress, y: rect.height)) // Bottom Right
        path.addLine(to: CGPoint(x: 0, y: rect.height)) // Bottom Left
        path.closeSubpath() // Close the Path
        return path
    }

    func rightToLeft(rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width - (rect.width * progress), y: 0))
        path.addLine(to: CGPoint(x: rect.width - (rect.width * progress), y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        return path
    }
}
