//
//  Nighttime.swift
//  Daylight
//
//  Created by Ben Farmer on 4/24/21.
//

import SwiftUI

struct Nighttime: View {
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
        .onDisappear(){
            timer.upstream.connect().cancel()
        }
        .onReceive(timer) {_ in
            viewModel.updateTimeData()
        }
    }
    
    var mainView: some View{
        ZStack{
            background
            moonGraphic
                .onTapGesture {
                    withAnimation{
                        clicked.toggle()
                    }
                }
        }
    }
    
    var background: some View{
        RadialGradient(gradient: Gradient(colors: [ Color(#colorLiteral(red: 0.4169208705, green: 0.4877590537, blue: 0.6206590533, alpha: 1) ), Color(  #colorLiteral(red: 0.1882352941, green: 0.2039215686, blue: 0.2235294118, alpha: 0.9142765411) )]), center: .center, startRadius: 2, endRadius: 312)
    }
    
    //TAB 1//***
    var moonGraphic: some View{
        ZStack{
            moonShadow
            
            if !clicked {
                moon
            }
            else {
                percentIndicator
            }
        }
    }
    
    var moonShadow: some View{
        CircleFull(fillColor: Color( #colorLiteral(red: 0.1768432284, green: 0.1971183778, blue: 0.2329204262, alpha: 1) ))
    }
    
    var moon: some View{
        CircleSlice(endAngle: viewModel.getEndAngle(), fillColor: Color( #colorLiteral(red: 0.426386714, green: 0.4582056999, blue: 0.4998273253, alpha: 1) ), whiteShadowOpacity: 0.1)
    }

    var percentIndicator: some View{
        Text("\(String(format: "%.1f", 100-viewModel.getPercentNighttimeElapsed()))%")
            .font(.largeTitle)
            .foregroundColor(Color(#colorLiteral(red: 0.426386714, green: 0.4582056999, blue: 0.4998273253, alpha: 1)))
    }
    
    //TAB 2//***
    var infoView: some View{
        ZStack{
            background
            nighttimeInfo
        }
    }
    
    var nighttimeInfo: some View{
        VStack{
            Text("Sunset: \(viewModel.getSunsetString())")
                .foregroundColor(Color( #colorLiteral(red: 0.1953838468, green: 0.2151450515, blue: 0.2484077811, alpha: 1) ))
            Text("Current Time: \(viewModel.getCurrentTimeString())")
                .foregroundColor(Color( #colorLiteral(red: 0.1953838468, green: 0.2151450515, blue: 0.2484077811, alpha: 1) ))
            Text("Sunrise: \(viewModel.getSunriseString())")
                .foregroundColor(Color( #colorLiteral(red: 0.1953838468, green: 0.2151450515, blue: 0.2484077811, alpha: 1) ))
            Text("")
            Text("Location: \(viewModel.locationData.locationName)")
                .foregroundColor(Color( #colorLiteral(red: 0.1953838468, green: 0.2151450515, blue: 0.2484077811, alpha: 1) ))
        }
    }
}

struct Nighttime_Previews: PreviewProvider {
    static var previews: some View {
        Nighttime()
    }
}
