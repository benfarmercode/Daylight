//
//  Home.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//

import SwiftUI

struct Home: View {
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
//            else{
//                Text("Waiting for location services...")
//            }
        }
    }
    
    var background: some View{
        RadialGradient(gradient: Gradient(colors: [ Color( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) ), Color( #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) )]), center: .center, startRadius: 2, endRadius: 312)
            .ignoresSafeArea()
    }
}

struct LocationService_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
