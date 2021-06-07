//
//  Colors.swift
//  Daylight
//
//  Created by Ben Farmer on 6/4/21.
//

import SwiftUI

protocol ColorScheme{
    var gradientInner: Color { get }
    var gradientOuter: Color { get }
    var text: Color { get }
    var iconBackground: Color { get }
    var slice: Color { get }
}

struct DayColors: ColorScheme{
    var gradientInner: Color    = Color( #colorLiteral(red: 0.8784313725, green: 0.7750043273, blue: 0.5811821818, alpha: 1) )
    var gradientOuter: Color    = Color( #colorLiteral(red: 0.9647058824, green: 0.7728223205, blue: 0.7040713429, alpha: 1) )
    var text: Color             = Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) )
    var iconBackground: Color   = Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 0.1266320634) )
    var slice: Color            = Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) )
}

struct DaybreakColors: ColorScheme{
    var gradientInner: Color    = Color( #colorLiteral(red: 0.9647058824, green: 0.7728223205, blue: 0.7040713429, alpha: 1) )
    var gradientOuter: Color    = Color( #colorLiteral(red: 0.7194175124, green: 0.7875497937, blue: 0.8418093324, alpha: 1) )
    var text: Color             = Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) )
    var iconBackground: Color   = Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 0.1266320634) )
    var slice: Color            = Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) )
}

struct GoldenHourColors: ColorScheme{
    var gradientInner: Color    = Color( #colorLiteral(red: 0.9655610919, green: 0.4850058556, blue: 0.3490667939, alpha: 1) )
    var gradientOuter: Color    = Color( #colorLiteral(red: 0.6364448667, green: 0.3618398905, blue: 0.4259202778, alpha: 1) )
    var text: Color             = Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 1) )
    var iconBackground: Color   = Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 0.1266320634) )
    var slice: Color            = Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) )
}

struct NightColors: ColorScheme{
    var gradientInner: Color    = Color( #colorLiteral(red: 0.4169208705, green: 0.4877590537, blue: 0.6206590533, alpha: 1) )
    var gradientOuter: Color    = Color( #colorLiteral(red: 0.1882352941, green: 0.2039215686, blue: 0.2235294118, alpha: 0.9142765411) )
    var text: Color             = Color( #colorLiteral(red: 0.1953838468, green: 0.2151450515, blue: 0.2484077811, alpha: 1) )
    var iconBackground: Color   = Color( #colorLiteral(red: 0.1768432284, green: 0.1971183778, blue: 0.2329204262, alpha: 1) )
    var slice: Color            = Color( #colorLiteral(red: 0.426386714, green: 0.4582056999, blue: 0.4998273253, alpha: 1) )
}

struct ColorsView: View{
    var dayColors = DayColors()
    var dayBreakColors = DaybreakColors()
    var goldenHourColors = GoldenHourColors()
    var nightColors = NightColors()
    
    
    var body: some View{
        
        TabView{
            BackgroundGradient(innerColor: dayBreakColors.gradientInner, outerColor: dayBreakColors.gradientOuter)
            BackgroundGradient(innerColor: dayColors.gradientInner, outerColor: dayColors.gradientOuter)
            BackgroundGradient(innerColor: goldenHourColors.gradientInner, outerColor: goldenHourColors.gradientOuter)
            BackgroundGradient(innerColor: nightColors.gradientInner, outerColor: nightColors.gradientOuter)
        }.tabViewStyle(PageTabViewStyle())
        
    }
}

struct ColorsView_Previews: PreviewProvider{
    static var previews: some View {
        ColorsView()
    }
}
