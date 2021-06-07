//
//  Home.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//

/*
change update from 1 second to 10 seconds
change time remaining to be accurate. 1 min left showed 0 minutes.
 change transition to sunset immediate. i think it is 1 minute extra
 */

import SwiftUI

struct Home: View {
    //MARK: PUBLIC
    @Environment(\.horizontalSizeClass) var sizeClass
    @StateObject var viewModel = ViewModel()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            background
            if viewModel.locationServiceComplete{
                Daylight()
            }
            else{
                locationServiceWarning
            }
        }
        .onAppear{
            viewModel.onLoad()
        }
        .sheet(isPresented: $viewModel.showOnboarding, onDismiss: {
            viewModel.dismissOnboardingSheet()
        }) {
            Onboarding()
        }
    }
    
    //MARK: PRIVATE
    private var background: some View{
        BackgroundGradient(innerColor: Color( #colorLiteral(red: 0.8784313725, green: 0.7750043273, blue: 0.5811821818, alpha: 1) ), outerColor: Color( #colorLiteral(red: 0.9647058824, green: 0.7728223205, blue: 0.7040713429, alpha: 1) ))
    }
    
    private var locationServiceWarning: some View{
        if self.viewModel.viewAppeared{
            return Text("Please enable location services.")
                .foregroundColor(Color(#colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1)))
                .font(Font.system(sizeClass == .compact ? .title3 : .largeTitle, design: .serif))
        }
        else{
            return Text("")
        }
    }
}

struct LocationService_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
