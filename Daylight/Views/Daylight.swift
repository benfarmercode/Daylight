//
//  DaylightView.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//

import SwiftUI

struct Daylight: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @StateObject var viewModel = ViewModel()
    @State var showTimeRemaining = false
    @State var showAnimatingView = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                background
                TabView{
                    sunGraphic
                    .onTapGesture {
                        withAnimation{
                            showTimeRemaining.toggle()
                        }
                    }
                    .onLongPressGesture {
                        showAnimatingView.toggle()
                        simpleSuccessHaptic()
                    }
                    
                    daylightInfo
                }
                .frame(
                    width: geometry.size.width ,
                    height: geometry.size.height
                )
                .tabViewStyle(PageTabViewStyle())
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.all)
                .onAppear{
                    viewModel.setup()
                    viewModel.reloadWidgets()
                }
                .onDisappear{
                    timer.upstream.connect().cancel()
                }
                .onReceive(timer) {_ in
                    viewModel.update()
                }
            }
        }
    }
    
    var background: some View{
        BackgroundGradient(innerColor: Color( #colorLiteral(red: 0.8784313725, green: 0.7750043273, blue: 0.5811821818, alpha: 1) ), outerColor: Color( #colorLiteral(red: 0.9647058824, green: 0.7728223205, blue: 0.7040713429, alpha: 1) ))
    }
    
    var sunGraphic: some View{
        ZStack{
            sunShadow
            
            if !showTimeRemaining {
                sun
            }
            else {
                remainingTime
            }
            
            if showAnimatingView{
                CircleAnimationDay(viewModel: self.viewModel, isShowing: $showAnimatingView)
            }
        }
    }
    
    var sunShadow: some View{
        CircleFull(radius: globalScreenWidth *  0.35, fillColor: Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 0.1266320634) ), forWidget: false, widgetType: nil)
    }
    
    var sun: some View{
        CircleSlice(radius: globalScreenWidth *  0.35, endAngle: viewModel.endAngle, fillColor:  Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ), whiteShadowOpacity: 0.4, forWidget: false, widgetType: nil)
    }
    
    var remainingTime: some View{
        VStack{
            Text("\(viewModel.remainingDaylight) remains.")
        }
        .font(Font.system(sizeClass == .compact ? .title3 : .largeTitle, design: .serif))
        .foregroundColor(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
    }
    
    var daylightInfo: some View{
        VStack{
            Text("Sunrise: \(viewModel.sunrise)")
            Text("Sunset: \(viewModel.sunset)")
            Text("")
            Text("Location: \(LocationManager.shared.locationData.locationName)")
        }
        .font(Font.system(sizeClass == .compact ? .title3 : .largeTitle, design: .serif))
        .foregroundColor(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
    }
    
    func simpleSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

struct DaylightView_Previews: PreviewProvider {
    static var previews: some View {
        Daylight()
    }
}
