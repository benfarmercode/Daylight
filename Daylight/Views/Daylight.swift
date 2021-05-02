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
            viewModel.setup(locationData: LocationManager.shared.locationData)
        }
        .onReceive(timer) {_ in
        }
    }
    
    var mainView: some View{
        ZStack{
            background
            VStack{
                sunGraphic
                    .onTapGesture {
                        withAnimation{
                            clicked.toggle()
                        }
                    }
            }
        }
    }
    
    var background: some View{
        RadialGradient(gradient: Gradient(colors: [ Color( #colorLiteral(red: 0.8784313725, green: 0.7750043273, blue: 0.5811821818, alpha: 1) ), Color( #colorLiteral(red: 0.9647058824, green: 0.7728223205, blue: 0.7040713429, alpha: 1) )]), center: .center, startRadius: 2, endRadius: 312)
            .ignoresSafeArea()
    }
    
    //TAB 1//***
    var sunGraphic: some View{
        ZStack{
            sunShadow
            
            if !clicked {
                sun
            }
            else {
                percentIndicator
            }
        }
    }
    
    var sunShadow: some View{
        CircleFull(fillColor: Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 0.1266320634) ))
    }
    
    var sun: some View{
        CircleSlice(endAngle: viewModel.getEndAngle(), fillColor:  Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ), whiteShadowOpacity: 0.4)
    }
    
    var percentIndicator: some View{
        Text("\(String(format: "%.1f", 100-viewModel.getPercentDaylightElapsed()))%")
            .font(.largeTitle)
            .foregroundColor(Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ))
    }
    
    //TAB 2//***
    var infoView: some View{
        ZStack{
            background
            VStack{
                daylightInfo
            }
        }
    }
    
    
    var daylightInfo: some View{
        VStack{
            Text("Sunrise: \(viewModel.getSunriseString())")
                .foregroundColor(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
            Text("Current Time: \(viewModel.getCurrentTimeString())")
                .foregroundColor(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
            Text("Sunset: \(viewModel.getSunsetString())")
                .foregroundColor(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
            Text("")
            Text("Location: \(viewModel.locationData.locationName)")
                .foregroundColor(Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) ))
        }
        
    }
}

struct DaylightView_Previews: PreviewProvider {
    static var previews: some View {
        Daylight()
    }
}
