//
//  DaylightView.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//

import SwiftUI

struct Daylight: View {
    //MARK: PUBLIC
    @Environment(\.horizontalSizeClass) var sizeClass
    @StateObject var viewModel = ViewModel()
    let updateTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                background
                TabView{
                    //TAB 1//
                    mainIcon
                        .onTapGesture {
                            withAnimation{
                                viewModel.showTimeRemaining.toggle()
                            }
                        }
                        .onLongPressGesture {
                            viewModel.showAnimatingView.toggle()
                            simpleSuccessHaptic()
                        }
                    
                    //TAB 2//
                    ZStack{
                        info
                        
                        helpButton
                            .onTapGesture {
                                viewModel.showOnboarding.toggle()
                            }
                            .padding(.all, globalDeviceWidth * 0.1)
                            .sheet(isPresented: $viewModel.showOnboarding){
                                Onboarding()
                            }
                    }
                }
                .frame(
                    width: geometry.size.width ,
                    height: geometry.size.height
                )
                .tabViewStyle(PageTabViewStyle())
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.all)
            }.onAppear{
                viewModel.setup()
                viewModel.reloadWidgets()
            }
            .onDisappear{
                updateTimer.upstream.connect().cancel()
            }
            .onReceive(updateTimer) {_ in
                viewModel.update()
            }
        }
    }
    
    //MARK: PRIVATE
    private var background: some View{
        if viewModel.isDaytime{
            return BackgroundGradient(
                innerColor: viewModel.dayColors.gradientInner,
                outerColor: viewModel.dayColors.gradientOuter
            ).transition(.opacity)
            .id("background1")
        }
        else{
            return BackgroundGradient(
                innerColor: viewModel.nightColors.gradientInner,
                outerColor: viewModel.nightColors.gradientOuter
            ).transition(.opacity)
            .id("background2")
        }
    }
    
    private var mainIcon: some View{
        ZStack{
            iconBackground
            
            if !viewModel.showTimeRemaining {
                iconSlice
            }
            else {
                remainingTime
            }
            
            if viewModel.showAnimatingView{
                CircleAnimation(viewModel: viewModel, isShowing: $viewModel.showAnimatingView)
            }
        }
    }
    
    private var iconBackground: some View{
        if viewModel.isDaytime{
            return CircleFull(
                radius: globalDeviceWidth *  0.35,
                fillColor: viewModel.dayColors.iconBackground,
                forWidget: false,
                widgetType: nil
            )
        }
        else{
            return CircleFull(
                radius: globalDeviceWidth *  0.35,
                fillColor: viewModel.nightColors.iconBackground,
                forWidget: false,
                widgetType: nil
            )
        }
    }
    
    private var iconSlice: some View{
        if viewModel.isDaytime{
            return CircleSlice(
                radius: globalDeviceWidth *  0.35,
                endAngle: viewModel.endAngle,
                fillColor: viewModel.dayColors.slice,
                whiteShadowOpacity: 0.4,
                forWidget: false,
                widgetType: nil
            )
        }
        else{
            return CircleSlice(
                radius: globalDeviceWidth *  0.35,
                endAngle: viewModel.endAngle,
                fillColor: viewModel.nightColors.slice,
                whiteShadowOpacity: 0.1,
                forWidget: false,
                widgetType: nil
            )
        }
    }
    
    private var remainingTime: some View{
        VStack{
            let lastWord = viewModel.isDaytime ? "sunset" : "sunrise"
            Text("\(viewModel.remainingTime) to \(lastWord).")
        }
        .font(Font.system(sizeClass == .compact ? .title3 : .largeTitle, design: .serif))
        .foregroundColor(viewModel.isDaytime ? viewModel.dayColors.text : viewModel.nightColors.slice)
    }
    
    private var info: some View{
        VStack{
            if(viewModel.isDaytime){
                Text("Sunrise: \(viewModel.sunrise)")
                Text("Sunset: \(viewModel.sunset)")
            }
            else{
                Text("Sunset: \(viewModel.sunset)")
                Text("Sunrise: \(viewModel.sunrise)")
            }
            
            Text("")
            Text("Location: \(LocationManager.shared.locationData.locationName)")
        }
        .font(Font.system(sizeClass == .compact ? .title3 : .largeTitle, design: .serif))
        .foregroundColor(viewModel.isDaytime ? viewModel.dayColors.text : viewModel.nightColors.text)
    }
    
    private var helpButton: some View{
        VStack{
            HStack{
                Spacer()
                Image(systemName: "questionmark.square")
                    .foregroundColor(viewModel.isDaytime ? viewModel.dayColors.text : viewModel.nightColors.text)
            }
            Spacer()
        }
        
    }
    
    private func simpleSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}



struct DaylightView_Previews: PreviewProvider {
    static var previews: some View {
        Daylight()
    }
}
