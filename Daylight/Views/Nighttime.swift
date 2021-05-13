//
//  Nighttime.swift
//  Daylight
//
//  Created by Ben Farmer on 4/24/21.
//

import SwiftUI

struct Nighttime: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @StateObject var viewModel = ViewModel()
    @State var clicked = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                background
                TabView{
                    moonGraphic
                        .onTapGesture {
                            withAnimation{
                                clicked.toggle()
                            }
                        }
                    nighttimeInfo
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
        BackgroundGradient(innerColor: Color( #colorLiteral(red: 0.4169208705, green: 0.4877590537, blue: 0.6206590533, alpha: 1) ), outerColor: Color( #colorLiteral(red: 0.1882352941, green: 0.2039215686, blue: 0.2235294118, alpha: 0.9142765411) ))
    }
    
    var moonGraphic: some View{
        ZStack{
            moonShadow
            
            if !clicked {
                moon
            }
            else {
                remainingTime
            }
        }
    }
    
    var moonShadow: some View{
        GeometryReader{ bounds in
            CircleFull(radius: globalScreenWidth *  0.35, fillColor: Color( #colorLiteral(red: 0.1768432284, green: 0.1971183778, blue: 0.2329204262, alpha: 1) ), forWidget: false, widgetType: nil)
        }
       
    }
    
    var moon: some View{
        CircleSlice(radius: globalScreenWidth *  0.35, endAngle: viewModel.endAngle, fillColor: Color( #colorLiteral(red: 0.426386714, green: 0.4582056999, blue: 0.4998273253, alpha: 1) ), whiteShadowOpacity: 0.1, forWidget: false, widgetType: nil)
    }
    
    var remainingTime: some View{
        VStack{
            Text("\(viewModel.remainingNighttime) remains.")
        }
        .font(Font.system(sizeClass == .compact ? .title3 : .largeTitle, design: .serif))
        .foregroundColor(Color( #colorLiteral(red: 0.426386714, green: 0.4582056999, blue: 0.4998273253, alpha: 1) ))
    }
    
    var nighttimeInfo: some View{
        VStack{
            Text("Sunset: \(viewModel.sunset)")
            Text("Sunrise: \(viewModel.sunrise)")
            Text("")
            Text("Location: \(LocationManager.shared.locationData.locationName)")
        }
        .font(Font.system(sizeClass == .compact ? .title3 : .largeTitle, design: .serif))
        .foregroundColor(Color( #colorLiteral(red: 0.1953838468, green: 0.2151450515, blue: 0.2484077811, alpha: 1) ))
    }
}

struct Nighttime_Previews: PreviewProvider {
    static var previews: some View {
        Nighttime()
    }
}
