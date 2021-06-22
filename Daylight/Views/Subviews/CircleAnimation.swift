//
//  CircleAnimation.swift
//  Daylight
//
//  Created by Ben Farmer on 6/4/21.
//

import SwiftUI

struct CircleAnimation: View{
    @StateObject var viewModel: Daylight.ViewModel
    @Environment(\.horizontalSizeClass) var sizeClass
    @State var fill: CGFloat = 0.0
    @State var moveAlongCircle = false
    @State var animationComplete = false
    @State var prefix = "11"
    
    @Binding var isShowing: Bool
    
    var body: some View{
        // Track Circle
        ZStack{
            Circle()
                .stroke(Color.black.opacity(0.3),
                        style: StrokeStyle(lineWidth: globalScreenWidth * 0.07))
                .frame(width: globalScreenWidth *  0.7, height: globalScreenWidth *  0.7)
            
            // Animation Circle
            Circle()
                .trim(from: 0, to: self.fill)
                .stroke(viewModel.isDaytime ? viewModel.dayColors.text : viewModel.nightColors.text,
                        style: StrokeStyle(lineWidth: globalScreenWidth * 0.07))
                .rotationEffect(.init(degrees: -90))
                .frame(width: globalScreenWidth *  0.7, height: globalScreenWidth *  0.7)
                .onAnimationCompleted(for: self.fill) {
                    withAnimation{
                        animationComplete = true
                    }
                }
                .onAppear(perform: {
                    withAnimation(Animation.easeInOut(duration: 1.5)){
                        self.fill = 1.0
                        self.moveAlongCircle.toggle()
                    }
                })
            
            //full sun
            Circle()
                .fill(viewModel.isDaytime ? viewModel.dayColors.slice : viewModel.nightColors.slice).opacity(Double(self.fill))
                .frame(width: globalScreenWidth *  0.7, height: globalScreenWidth *  0.7)
            
            //small circle
            Circle()
                .fill(viewModel.isDaytime ? viewModel.dayColors.text : viewModel.nightColors.text)
                .frame(width: globalScreenWidth * 0.15, height: globalScreenWidth * 0.15)
                .offset(y: -globalScreenWidth * 0.35)
                .rotationEffect(.degrees(moveAlongCircle ? 360 : 0))
                .animation(Animation.easeInOut(duration: 1.5))
            
            if animationComplete{
                let lastWord = viewModel.isDaytime ? "daylight" : "nighttime"
                VStack{
                    Text("Total \(lastWord):")
                    Text(prefix + " hours " + viewModel.totalTime.suffix(2) + " minutes")
                    //                Text(viewModel.totalTime.suffix(2)+" Minutes")
                }
                .font(Font.system(sizeClass == .compact ? .title3 : .largeTitle, design: .serif))
                .foregroundColor(viewModel.isDaytime ? viewModel.dayColors.text : viewModel.nightColors.text)
            }
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(Animation.default){
                isShowing = false
            }
        }
        .onAppear{
            prefix = String(viewModel.totalTime.prefix(2))
            print(prefix)
            print(prefix.prefix(1))
            print(prefix[0])
            if prefix[0] == "0"{
                prefix = String(prefix[1])
            }
        }
    }
}


struct CircleAnimation_Previews: PreviewProvider {
    static var previews: some View {
        CircleAnimation(viewModel: Daylight.ViewModel(), isShowing: .constant(true))
    }
}

