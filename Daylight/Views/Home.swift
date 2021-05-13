//
//  Home.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//

import SwiftUI

struct Home: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @StateObject var viewModel = ViewModel()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            background
                .onAppear(){
                    viewModel.runLocationService()
                    viewModel.scheduleMinuteChangeTimer()
                }
            
            if viewModel.locationServiceComplete{
                if viewModel.isDaytime{
                    Daylight()
                        .transition(.opacity)
                }
                else{
                    Nighttime()
                        .transition(.opacity)
                }
            }
            else{
                Text("Please enable location services.")
                    .foregroundColor(Color(#colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1)))
                    .font(Font.system(sizeClass == .compact ? .title3 : .largeTitle, design: .serif))
            }
        }
    }
    
    var background: some View{
        BackgroundGradient(innerColor: Color( #colorLiteral(red: 0.8784313725, green: 0.7750043273, blue: 0.5811821818, alpha: 1) ), outerColor: Color( #colorLiteral(red: 0.9647058824, green: 0.7728223205, blue: 0.7040713429, alpha: 1) ))
    }
}

struct LocationService_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
