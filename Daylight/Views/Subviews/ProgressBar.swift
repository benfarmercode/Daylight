//
//  ProgressBar.swift
//  Daylight
//
//  Created by Ben Farmer on 6/4/21.
//

import SwiftUI


struct ProgressBar: View {
    var id: Int
    @Binding var selectedPage: Int
    @Binding var value: Float
    
    var body: some View{
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                Rectangle().frame(
                    width: self.getWidth(geometryWidth: geometry.size.width),
                    height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                //                    .animation(.linear)
            }.cornerRadius(45.0)
            .padding(.top, 5)
        }
    }
    
    func getWidth(geometryWidth: CGFloat) -> CGFloat{
        if self.selectedPage == self.id{
            return min(CGFloat(self.value) * geometryWidth, geometryWidth)
        }
        else if self.selectedPage < self.id{
            return min(CGFloat(0.0) * geometryWidth, geometryWidth)
        }
        else{
            return min(CGFloat(1.0) * geometryWidth, geometryWidth)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(id: 3, selectedPage: .constant(4), value: .constant(0.5))
            .frame(height: 20)
    }
}
