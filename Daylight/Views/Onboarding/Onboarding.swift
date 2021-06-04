//
//  Onboarding.swift
//  Daylight
//
//  Created by Ben Farmer on 5/13/21.
//

import SwiftUI

struct Onboarding: View {
    let id = UUID()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var sizeClass
    
    @StateObject var viewModel = ViewModel()

    @State var fill: CGFloat = 0.0
    @State var moveAlongCircle = false
    @State var animationComplete = false
    
//    @Binding var isShowing: Bool
    
    
    @State var scale: CGFloat = 1
    @State var yOffset1: CGFloat = 0.0
    @State var yOffset2: CGFloat = 0.0
    @State var yOffset3: CGFloat = 0.0
    @State var yOffset4: CGFloat = 0.0
    @State var yOffset6: CGFloat = 0.0
    @State var opacity1: Double = 0.0
    @State var opacity2: Double = 0.0
    @State var opacity3: Double = 0.0
    @State var opacity4: Double = 0.0
    @State var opacity6: Double = 0.0
    @State var tapped = false
    @State var held = false
    //    @State var position: CGPoint = .zero
    
    var body: some View {
        
        ZStack{
            HStack{
                Spacer()
                switch viewModel.selectedPage {
                case 1:
                    VStack{
                        Spacer()
                        page1
                        Spacer()
                    }
                    
                case 2:
                    VStack{
                        Spacer()
                        page2
                        Spacer()
                    }
                    
                case 3:
                    VStack{
                        Spacer()
                        page3
                        Spacer()
                    }
                    
                case 4:
                    VStack{
                        Spacer()
                        page4
                        Spacer()
                    }
                    
                case 5:
                    VStack{
                        Spacer()
                        page5
                        Spacer()
                    }
                    
                case 6:
                    VStack{
                        Spacer()
                        page6
                        Spacer()
                    }
                    
                default:
                    Spacer()
                //                Text("Hooo")
                
                }
                Spacer()
                //        }.onRotate { _ in
                //            self.viewModel.checkDeviceOrientation()
                //        }
                
            }.onAppear{
                self.viewModel.fireTimer()
                //        .gesture(
                //            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                //                .onChanged { value in
                //                    self.position = value.location
                //                }
                //                .onEnded { _ in
                //                    self.position = .zero
                //                }
                //        )
                //        .border(Color.red)
            }
            .contentShape(Rectangle())
            .onClickGesture { point in
                if point.x > globalDeviceWidth * 0.5 {
                    self.viewModel.selectedPage += 1
                    print("plus \(point.x)")
                }
                //            if self.viewModel.selectedPage == 7{
                //                self.presentationMode.wrappedValue.dismiss()
                //            }
                else {
                    self.viewModel.selectedPage -= 1
                    print("minus \(point.x)")
                    
                    if self.viewModel.selectedPage < 1{
                        self.viewModel.selectedPage = 1
                    }
                }
                if self.viewModel.selectedPage == 7 {
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            }
            .border(Color.red)
            
            
            VStack{
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: globalDeviceWidth * 0.9, height: globalDeviceHeight * 0.01)
                    .padding(.all, 5)
                
                Spacer()
            }
            
        }
    }
    
    var page1: some View{
        VStack(spacing: 30){
            Text("Welcome to Daylight!")
            Image(uiImage: Bundle.main.icon!)
                .resizable()
                .frame(width: 100, height: 100)
        }.foregroundColor(Color(#colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1)))
        .font(Font.system(sizeClass == .compact ? .subheadline : .title2, design: .serif))
        //        .scaleEffect(scale)
        .offset(y: yOffset1)
        .opacity(opacity1)
        .onAppear {
            let baseAnimation = Animation.easeInOut(duration: 1)
            let repeated = baseAnimation.repeatForever(autoreverses: true)
            
            withAnimation(repeated) {
                yOffset1 = 5.0
            }
            
            let opacityAnimation = Animation.easeInOut(duration: 1.5)
            
            withAnimation(opacityAnimation){
                opacity1 = 1.0
            }
        }
        .onDisappear{
            let baseAnimation = Animation.easeInOut(duration: 1)
            let repeated = baseAnimation.repeatForever(autoreverses: true)
            
            withAnimation(repeated) {
                yOffset1 = 0.0
            }
            
            let opacityAnimation = Animation.easeInOut(duration: 1.5)
            
            withAnimation(opacityAnimation){
                opacity1 = 0.0
            }
        }
    }
    
    var page2: some View{
        VStack (spacing: 30){
            Spacer()
            locationIcon
            Text("This app uses location services.") + Text(" Please select 'Allow While Using App' when prompted.").bold()
            Spacer()
        }.foregroundColor(Color(#colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1)))
        .font(Font.system(sizeClass == .compact ? .subheadline : .title2, design: .serif))
        .offset(y: yOffset2)
        .opacity(opacity2)
        .onAppear {
            let baseAnimation = Animation.easeInOut(duration: 1)
            let repeated = baseAnimation.repeatForever(autoreverses: true)
            
            withAnimation(repeated) {
                yOffset2 = 5.0
            }
            
            let opacityAnimation = Animation.easeInOut(duration: 1.5)
            
            withAnimation(opacityAnimation){
                opacity2 = 1.0
            }
        }
        .onDisappear{
            let baseAnimation = Animation.easeInOut(duration: 1)
            let repeated = baseAnimation.repeatForever(autoreverses: true)
            
            withAnimation(repeated) {
                yOffset2 = 0.0
            }
            
            let opacityAnimation = Animation.easeInOut(duration: 1.5)
            
            withAnimation(opacityAnimation){
                opacity2 = 0.0
            }
        }
    }
    
    var page3: some View{
        VStack(spacing: 30){
            Spacer()
            sunIcon
            Text("The 'solar clock' is a visual representation of the remaining daylight.")
            Spacer()
            
        }.foregroundColor(Color(#colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1)))
        .font(Font.system(sizeClass == .compact ? .subheadline : .title2, design: .serif))
        .offset(y: yOffset3)
        .opacity(opacity3)
        .onAppear {
            let baseAnimation = Animation.easeInOut(duration: 1)
            let repeated = baseAnimation.repeatForever(autoreverses: true)
            
            withAnimation(repeated) {
                yOffset3 = 5.0
            }
            
            let opacityAnimation = Animation.easeInOut(duration: 1.0)
            
            withAnimation(opacityAnimation){
                opacity3 = 1.0
            }
        }
        .onDisappear{
            let baseAnimation = Animation.easeInOut(duration: 1)
            let repeated = baseAnimation.repeatForever(autoreverses: true)
            
            withAnimation(repeated) {
                yOffset3 = 0.0
            }
            
            let opacityAnimation = Animation.easeInOut(duration: 1.5)
            
            withAnimation(opacityAnimation){
                opacity3 = 0.0
            }
        }
    }
    
    var page4: some View{
        VStack(spacing: 30){
            Spacer()
            if tapped{
                timeRemainingDayIcon
            }
            else{
                sunIcon
            }
           
            Text("Tap the icon to get the hours and minutes until sunset.")
            Spacer()
            
        }.foregroundColor(Color(#colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1)))
        .font(Font.system(sizeClass == .compact ? .subheadline : .title2, design: .serif))
        .offset(y: yOffset3)
//        .opacity(opacity4)
        .onAppear {
            let baseAnimation = Animation.easeInOut(duration: 1)
            let repeated = baseAnimation.repeatForever(autoreverses: true)
            let delayChange = Animation.easeInOut(duration: 1).delay(0.5)
            
            withAnimation(repeated) {
                yOffset4 = 5.0
            }
            
//            let opacityAnimation = Animation.easeInOut(duration: 1.5)
            
//            withAnimation(opacityAnimation){
//                opacity4 = 1.0
//            }
            
            withAnimation (delayChange){
                tapped = true
            }
            
            
        }
        .onDisappear{
            let baseAnimation = Animation.easeInOut(duration: 1)
            let repeated = baseAnimation.repeatForever(autoreverses: true)
            let delayChange = Animation.easeInOut(duration: 1).delay(0.5)
            
            withAnimation(repeated) {
                yOffset4 = 0.0
            }
//
//            let opacityAnimation = Animation.easeInOut(duration: 1.5)
//
//            withAnimation(opacityAnimation){
//                opacity4 = 0.0
//            }
            
            withAnimation (delayChange){
                tapped = false
            }
        }
    }
    
    var page5: some View{
        VStack(spacing: 30){
            Spacer()
            if held{
                totalTimeIcon
            }
            else{
                sunIcon
            }
           
            Text("Hold the icon to get the total amount of daylight in hours and minutes.")
            Spacer()
            
        }.foregroundColor(Color(#colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1)))
        .font(Font.system(sizeClass == .compact ? .subheadline : .title2, design: .serif))
        .offset(y: yOffset4)
//        .opacity(opacity4)
        .onAppear {
            let baseAnimation = Animation.easeInOut(duration: 1)
            let repeated = baseAnimation.repeatForever(autoreverses: true)
            let delayChange = Animation.easeInOut(duration: 1).delay(0.5)
            
            withAnimation(repeated) {
                yOffset4 = 5.0
            }
            
            withAnimation (delayChange){
                held = true
            }
            
            
        }
        .onDisappear{
            let baseAnimation = Animation.easeInOut(duration: 1)
            let repeated = baseAnimation.repeatForever(autoreverses: true)
            let delayChange = Animation.easeInOut(duration: 1).delay(0.5)

            withAnimation(repeated) {
                yOffset4 = 0.0
            }
            withAnimation (delayChange){
                held = false
            }
        }
    }
    
    var page6: some View{
        ZStack{
            
            BackgroundGradient(innerColor: Color( #colorLiteral(red: 0.4169208705, green: 0.4877590537, blue: 0.6206590533, alpha: 1) ), outerColor: Color( #colorLiteral(red: 0.1882352941, green: 0.2039215686, blue: 0.2235294118, alpha: 0.4611782962) ))
            
            VStack(spacing: 30){
                Spacer()
                if tapped{
                    timeRemainingNightIcon
                }
                else{
                    moonIcon
                }
                Text("After sunset the app tracks the time until sunrise.")
                Spacer()
                
            }.foregroundColor(Color(  #colorLiteral(red: 0.1953838468, green: 0.2151450515, blue: 0.2484077811, alpha: 1) ))
            .font(Font.system(sizeClass == .compact ? .subheadline : .title2, design: .serif))

            .offset(y: yOffset6)
            .onAppear{
                let baseAnimation = Animation.easeInOut(duration: 1)
                let repeated = baseAnimation.repeatForever(autoreverses: true)
                let delayChange = Animation.easeInOut(duration: 1).delay(2.5)
                let opacityAnimation = Animation.easeInOut(duration: 1.5)
                
                withAnimation(repeated) {
                    yOffset6 = 5.0
                }
                
                withAnimation (delayChange){
                    tapped = true
                }
                
                withAnimation(opacityAnimation){
                    opacity6 = 1.0
                }
            }
            .onDisappear{
                let baseAnimation = Animation.easeInOut(duration: 1)
                let repeated = baseAnimation.repeatForever(autoreverses: true)
                let delayChange = Animation.easeInOut(duration: 1).delay(1.5)
                let opacityAnimation = Animation.easeInOut(duration: 1.5)
                
                withAnimation (delayChange){
                    tapped = false
                }
                
                withAnimation(opacityAnimation){
                    opacity6 = 0.0
                }
                
                withAnimation(repeated) {
                    yOffset6 = 0.0
                }
            }
            
        }
        .opacity(opacity6)
    }
    
    var moonIcon: some View{
        ZStack{
            CircleFull(radius: globalScreenWidth *  0.25, fillColor: Color( #colorLiteral(red: 0.1768432284, green: 0.1971183778, blue: 0.2329204262, alpha: 1) ), forWidget: false, widgetType: nil)
                .frame(width: globalScreenWidth *  0.5, height: globalScreenWidth *  0.5)
            CircleSlice(radius: globalScreenWidth *  0.25, endAngle: Double.pi * 0.3, fillColor: Color( #colorLiteral(red: 0.426386714, green: 0.4582056999, blue: 0.4998273253, alpha: 1) ), whiteShadowOpacity: 0.1, forWidget: false, widgetType: nil)
                .frame(width: globalScreenWidth *  0.5, height: globalScreenWidth *  0.5)
        }
    }

    var locationIcon: some View{
        Image(systemName: "location.circle")
            .resizable()
            .frame(width: globalScreenWidth *  0.5, height: globalScreenWidth *  0.5)
            .foregroundColor(Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ))
    }
    
    var sunIcon: some View{
        ZStack{
            CircleFull(radius: globalScreenWidth *  0.25, fillColor: Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 0.1266320634) ), forWidget: false, widgetType: nil)
                .frame(width: globalScreenWidth *  0.5, height: globalScreenWidth *  0.5)
            CircleSlice(radius: globalScreenWidth *  0.25, endAngle: Double.pi * 0.3, fillColor:  Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ), whiteShadowOpacity: 0.4, forWidget: false, widgetType: nil)
                .frame(width: globalScreenWidth *  0.5, height: globalScreenWidth *  0.5)
        }
    }
    
    var timeRemainingDayIcon: some View{
        ZStack{
            CircleFull(radius: globalScreenWidth *  0.25, fillColor: Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 0.1266320634) ), forWidget: false, widgetType: nil)
                .frame(width: globalScreenWidth *  0.5, height: globalScreenWidth *  0.5)
            Text("5:34 to sunset.")
                .font(Font.system(sizeClass == .compact ? .title3 : .largeTitle, design: .serif))
                .foregroundColor(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
            
        }
    }
    
    var timeRemainingNightIcon: some View{
        ZStack{
            CircleFull(radius: globalScreenWidth *  0.25, fillColor: Color( #colorLiteral(red: 0.1768432284, green: 0.1971183778, blue: 0.2329204262, alpha: 1) ), forWidget: false, widgetType: nil)
                .frame(width: globalScreenWidth *  0.5, height: globalScreenWidth *  0.5)
            Text("5:34 to sunrise.")
                .font(Font.system(sizeClass == .compact ? .title3 : .largeTitle, design: .serif))
                .foregroundColor(Color( #colorLiteral(red: 0.426386714, green: 0.4582056999, blue: 0.4998273253, alpha: 1) ))
            
        }
    }
    
    var totalTimeIcon: some View{
        // Track Circle
        ZStack{
            Circle()
                .stroke(Color.black.opacity(0.3),
                        style: StrokeStyle(lineWidth: globalScreenWidth * 0.07))
                .frame(width: globalScreenWidth *  0.5, height: globalScreenWidth *  0.5)
            
            // Animation Circle
            Circle()
                .trim(from: 0, to: self.fill)
                .stroke(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ),
                        style: StrokeStyle(lineWidth: globalScreenWidth * 0.07))
                .rotationEffect(.init(degrees: -90))
                .frame(width: globalScreenWidth *  0.5, height: globalScreenWidth *  0.5)
                .onAnimationCompleted(for: self.fill) {
                    withAnimation{
                        animationComplete = true
                    }
                }
                .onAppear(perform: {
                    withAnimation(Animation.easeInOut(duration: 1.5).delay(0.75)){
                        self.fill = 1.0
                        self.moveAlongCircle = true
                    }
                })
                .onDisappear{
                    self.fill = 0.0
                    self.moveAlongCircle = false
                }
            
            //full sun
            Circle()
                .fill(Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ).opacity(Double(self.fill)))
                .frame(width: globalScreenWidth *  0.5, height: globalScreenWidth *  0.5)
            
            //small circle
            Circle()
                .fill(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
                .frame(width: globalScreenWidth * 0.1, height: globalScreenWidth * 0.1)
                .offset(y: -globalScreenWidth * 0.25)
                .rotationEffect(.degrees(moveAlongCircle ? 360 : 0))
                .animation(Animation.easeInOut(duration: 1.5).delay(0.75))
            
            if animationComplete{
                Text("Total Daylight: 14:40")
                    .font(Font.system(sizeClass == .compact ? .callout : .callout, design: .serif))
                    .foregroundColor(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
            }
            
        }
        .contentShape(Rectangle())
//        .onTapGesture {
//            withAnimation(Animation.default){
//                isShowing = false
//            }
//        }
    }
    
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
