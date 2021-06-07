//
//  SplashAnimation.swift
//  Daylight
//
//  Created by Ben Farmer on 6/4/21.
//

import SwiftUI

import SwiftUI


struct ProgressBars: View {
    @Binding var selectedPage: Int
    @Binding var value: Float
    
    var body: some View {
        HStack{
            ProgressBar(id: 1, selectedPage: $selectedPage, value: $value)
            ProgressBar(id: 2, selectedPage: $selectedPage, value: $value)
            ProgressBar(id: 3, selectedPage: $selectedPage, value: $value)
            ProgressBar(id: 4, selectedPage: $selectedPage, value: $value)
            ProgressBar(id: 5, selectedPage: $selectedPage, value: $value)
            ProgressBar(id: 6, selectedPage: $selectedPage, value: $value)
        }.padding(.trailing, 10)
         .padding(.leading, 10)
        
    }
}

struct ProgressBars_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ProgressBars(selectedPage: .constant(1), value: .constant(0.2))
                .frame(height: 20)
            Spacer()
        }
        
    }
}
