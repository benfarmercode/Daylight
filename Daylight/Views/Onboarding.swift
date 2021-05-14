//
//  Onboarding.swift
//  Daylight
//
//  Created by Ben Farmer on 5/13/21.
//

import SwiftUI

struct Onboarding: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    var body: some View {
        ZStack{
            background
            VStack(spacing: 30){
                    Spacer()
                    Text("Welcome to Daylight!")
                    HStack{
                        Spacer()
                        locationIcon
                        Spacer()
                        Spacer()
                        Text(" This app requires location services to work. Please click 'Allow While Using App' when prompted.")
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        sunIcon
                        Spacer()
                        Spacer()
                        Text("The main icon indicates how much Daylight (or night) there is left in the day.")
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        totalTimeIcon
                        Spacer()
                        Spacer()
                        Text("Press and hold the icon to view the total amount of daylight. Tap to view how much time is remaining.")
                        Spacer()
                    }
                    Spacer()
                }
                .foregroundColor(Color(#colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1)))
                .font(Font.system(sizeClass == .compact ? .subheadline : .title2, design: .serif))
        }
    }
    
    var background: some View{
        BackgroundGradient(innerColor: Color( #colorLiteral(red: 0.9799187769, green: 0.9814854452, blue: 0.9816924941, alpha: 1) ), outerColor: Color( #colorLiteral(red: 1, green: 1, blue: 0.8633080051, alpha: 1) ))
    }
    
    var locationIcon: some View{
        Image(systemName: "location.circle")
            .resizable()
            .frame(width: globalScreenWidth *  0.3, height: globalScreenWidth *  0.3)
            .foregroundColor(Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ))
    }
    
    var sunIcon: some View{
        ZStack{
            CircleFull(radius: globalScreenWidth *  0.15, fillColor: Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 0.1266320634) ), forWidget: false, widgetType: nil)
                .frame(width: globalScreenWidth *  0.3, height: globalScreenWidth *  0.3)
            CircleSlice(radius: globalScreenWidth *  0.15, endAngle: Double.pi * 0.3, fillColor:  Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ), whiteShadowOpacity: 0.4, forWidget: false, widgetType: nil)
                .frame(width: globalScreenWidth *  0.3, height: globalScreenWidth *  0.3)
        }
    }
    
    var totalTimeIcon: some View{
        ZStack{
            Circle()
                .stroke(Color.black.opacity(0.3),
                        style: StrokeStyle(lineWidth: globalScreenWidth * 0.03))
                .frame(width: globalScreenWidth *  0.3, height: globalScreenWidth *  0.3)
            
            // Animation Circle
            Circle()
//                .trim(from: 0, to: self.fill)
                .stroke(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ),
                        style: StrokeStyle(lineWidth: globalScreenWidth * 0.03))
                .rotationEffect(.init(degrees: -90))
                .frame(width: globalScreenWidth *  0.3, height: globalScreenWidth *  0.3)
            
            //full sun
            Circle()
                .fill(Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ))
                .frame(width: globalScreenWidth *  0.3, height: globalScreenWidth *  0.3)
            
            //small circle
            Circle()
                .fill(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
                .frame(width: globalScreenWidth * 0.075, height: globalScreenWidth * 0.075)
                .offset(y: -globalScreenWidth * 0.15)
//                .rotationEffect(.degrees(moveAlongCircle ? 360 : 0))
            
                Text("Total Daylight: 14:04")
                    .font(Font.system(sizeClass == .compact ? .caption2 : .title2, design: .serif))
                    .foregroundColor(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
            
        }
        .contentShape(Rectangle())
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
