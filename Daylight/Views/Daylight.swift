//
//  DaylightView.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//

import SwiftUI

struct Daylight: View {
    @StateObject var viewModel = ViewModel()
    @State var clicked = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        // scrollview + frame used as workaround to TabView top edge ignore safe area bug
        ScrollView{
            TabView{
                mainView
                infoView
            }
            .frame(
                width: UIScreen.main.bounds.width ,
                height: UIScreen.main.bounds.height
            )
            .tabViewStyle(PageTabViewStyle())
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
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
    
    var mainView: some View{
        ZStack{
            background
            sunGraphic
                .onTapGesture {
                    withAnimation{
                        clicked.toggle()
                    }
                }
        }
    }
    
    var background: some View{
        BackgroundGradient(innerColor: Color( #colorLiteral(red: 0.8784313725, green: 0.7750043273, blue: 0.5811821818, alpha: 1) ), outerColor: Color( #colorLiteral(red: 0.9647058824, green: 0.7728223205, blue: 0.7040713429, alpha: 1) ))
    }
    
    //TAB 1//***
    var sunGraphic: some View{
        ZStack{
            sunShadow
            
            if !clicked {
                sun
            }
            else {
                remainingTime
            }
        }
    }
    
    var sunShadow: some View{
        CircleFull(radius: 128, fillColor: Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 0.1266320634) ), forWidget: false, widgetType: nil)
    }
    
    var sun: some View{
        CircleSlice(radius: 128, endAngle: viewModel.endAngle, fillColor:  Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ), whiteShadowOpacity: 0.4, forWidget: false, widgetType: nil)
    }
    
    var remainingTime: some View{
        VStack{
            Text("\(viewModel.remainingDaylight) remains.")
        }
        .font(.system(size: 18, design: .serif))
        .foregroundColor(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
    }
    
    //TAB 2//***
    var infoView: some View{
        ZStack{
            background
            daylightInfo
        }
    }
    
    
    var daylightInfo: some View{
        VStack{
            Text("Sunrise: \(viewModel.sunrise)")
            Text("Sunset: \(viewModel.sunset)")
            Text("")
            Text("Location: \(LocationManager.shared.locationData.locationName)")
        }
        .font(.system(size: 18, design: .serif))
        .foregroundColor(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
    }
}

struct DaylightView_Previews: PreviewProvider {
    static var previews: some View {
        Daylight()
    }
}
