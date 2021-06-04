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

struct CircleAnimationNight: View{
    @StateObject var viewModel: Nighttime.ViewModel
    @Environment(\.horizontalSizeClass) var sizeClass
    @State var fill: CGFloat = 0.0
    @State var moveAlongCircle = false
    @State var animationComplete = false
    
    @Binding var isShowing: Bool
    
    var body: some View{
        // Track Circle
        ZStack{
            Circle()
                .stroke(Color.black.opacity(0.3),
                        style: StrokeStyle(lineWidth: globalScreenWidth * 0.07))
                .frame(width: globalScreenWidth *  0.7, height: globalScreenWidth *  0.7)
            
            // Animation Circle
            Circle()
                .trim(from: 0, to: self.fill)
                .stroke(Color( #colorLiteral(red: 0.1768432284, green: 0.1971183778, blue: 0.2329204262, alpha: 1) ),
                        style: StrokeStyle(lineWidth: globalScreenWidth * 0.07))
                .rotationEffect(.init(degrees: -90))
                .frame(width: globalScreenWidth *  0.7, height: globalScreenWidth *  0.7)
                .onAnimationCompleted(for: self.fill) {
                    withAnimation{
                        animationComplete = true
                    }
                }
                .onAppear(perform: {
                    withAnimation(Animation.easeInOut(duration: 1.5)){
                        self.fill = 1.0
                        self.moveAlongCircle.toggle()
                    }
                })
            
            Circle()
                .fill(Color( #colorLiteral(red: 0.426386714, green: 0.4582056999, blue: 0.4998273253, alpha: 1) ).opacity(Double(self.fill)))
                .frame(width: globalScreenWidth *  0.7, height: globalScreenWidth *  0.7)
            
            
            Circle()
                .fill(Color( #colorLiteral(red: 0.1768432284, green: 0.1971183778, blue: 0.2329204262, alpha: 1) ))
                .frame(width: globalScreenWidth * 0.15, height: globalScreenWidth * 0.15)
                .offset(y: -globalScreenWidth * 0.35)
                .rotationEffect(.degrees(moveAlongCircle ? 360 : 0))
                .animation(Animation.easeInOut(duration: 1.5))
            
            if animationComplete{
                Text("Total Nighttime: \(viewModel.totalNighttime)")
                    .font(Font.system(sizeClass == .compact ? .title3 : .largeTitle, design: .serif))
                    .foregroundColor(Color( #colorLiteral(red: 0.1953838468, green: 0.2151450515, blue: 0.2484077811, alpha: 1) ))
            }
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(Animation.default){
                isShowing = false
            }
        }
    }
}

struct CircleAnimationDay: View{
    @StateObject var viewModel: Daylight.ViewModel
    @Environment(\.horizontalSizeClass) var sizeClass
    @State var fill: CGFloat = 0.0
    @State var moveAlongCircle = false
    @State var animationComplete = false
    
    @Binding var isShowing: Bool
    
    var body: some View{
        // Track Circle
        ZStack{
            Circle()
                .stroke(Color.black.opacity(0.3),
                        style: StrokeStyle(lineWidth: globalScreenWidth * 0.07))
                .frame(width: globalScreenWidth *  0.7, height: globalScreenWidth *  0.7)
            
            // Animation Circle
            Circle()
                .trim(from: 0, to: self.fill)
                .stroke(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ),
                        style: StrokeStyle(lineWidth: globalScreenWidth * 0.07))
                .rotationEffect(.init(degrees: -90))
                .frame(width: globalScreenWidth *  0.7, height: globalScreenWidth *  0.7)
                .onAnimationCompleted(for: self.fill) {
                    withAnimation{
                        animationComplete = true
                    }
                }
                .onAppear(perform: {
                    withAnimation(Animation.easeInOut(duration: 1.5)){
                        self.fill = 1.0
                        self.moveAlongCircle.toggle()
                    }
                })
            
            //full sun
            Circle()
                .fill(Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ).opacity(Double(self.fill)))
                .frame(width: globalScreenWidth *  0.7, height: globalScreenWidth *  0.7)
            
            //small circle
            Circle()
                .fill(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
                .frame(width: globalScreenWidth * 0.15, height: globalScreenWidth * 0.15)
                .offset(y: -globalScreenWidth * 0.35)
                .rotationEffect(.degrees(moveAlongCircle ? 360 : 0))
                .animation(Animation.easeInOut(duration: 1.5))
            
            if animationComplete{
                Text("Total Daylight: \(viewModel.totalDaylight)")
                    .font(Font.system(sizeClass == .compact ? .title3 : .largeTitle, design: .serif))
                    .foregroundColor(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
            }
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(Animation.default){
                isShowing = false
            }
        }
    }
}

struct Shapes_Previews: PreviewProvider {
    static var previews: some View {
        CircleAnimationNight(viewModel: Nighttime.ViewModel(), isShowing: .constant(true))
    }
}

