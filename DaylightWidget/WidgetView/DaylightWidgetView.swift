//
//  WidgetView.swift
//  Daylight
//
//  Created by Ben Farmer on 5/3/21.
//

import WidgetKit
import SwiftUI

//view
struct DaylightWidgetView : View {
    @Environment(\.widgetFamily) var family
    var entry: DaylightProvider.Entry

    var body: some View {
        
        switch family {
        case .systemSmall:
            smallView
        case .systemMedium:
            mediumView
        case .systemLarge:
            largeView
        default:
            smallView
        }
    }
    
    var smallView: some View{
        ZStack{
            if entry.isDaytime {
                BackgroundGradient(innerColor: Color( #colorLiteral(red: 0.8784313725, green: 0.7750043273, blue: 0.5811821818, alpha: 1) ), outerColor: Color( #colorLiteral(red: 0.9647058824, green: 0.7728223205, blue: 0.7040713429, alpha: 1) ))
                CircleFull(radius: 48, fillColor: Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 0.1266320634) ), forWidget: true, widgetType: .small)
                CircleSlice(radius: 48, endAngle: entry.endAngle, fillColor:  Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ), whiteShadowOpacity: 0.4, forWidget: true, widgetType: .small)
            }
            else {
                BackgroundGradient(innerColor: Color( #colorLiteral(red: 0.4169208705, green: 0.4877590537, blue: 0.6206590533, alpha: 1) ), outerColor:Color( #colorLiteral(red: 0.1882352941, green: 0.2039215686, blue: 0.2235294118, alpha: 0.9142765411) ))
                 CircleFull(radius: 48, fillColor: Color( #colorLiteral(red: 0.1768432284, green: 0.1971183778, blue: 0.2329204262, alpha: 1) ), forWidget: true, widgetType: .small)
                 CircleSlice(radius: 48, endAngle: entry.endAngle, fillColor: Color( #colorLiteral(red: 0.426386714, green: 0.4582056999, blue: 0.4998273253, alpha: 1) ), whiteShadowOpacity: 0.1, forWidget: true, widgetType: .small)
            }
        }
    }
    
    var mediumView: some View{
        ZStack{
            if entry.isDaytime {
                BackgroundGradient(innerColor: Color( #colorLiteral(red: 0.8784313725, green: 0.7750043273, blue: 0.5811821818, alpha: 1) ), outerColor: Color( #colorLiteral(red: 0.9647058824, green: 0.7728223205, blue: 0.7040713429, alpha: 1) ))
                CircleFull(radius: 64, fillColor: Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 0.1266320634) ), forWidget: true, widgetType: .medium)
                CircleSlice(radius: 64, endAngle: entry.endAngle, fillColor:  Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ), whiteShadowOpacity: 0.4, forWidget: true, widgetType: .medium)
            }
            else {
                BackgroundGradient(innerColor: Color( #colorLiteral(red: 0.4169208705, green: 0.4877590537, blue: 0.6206590533, alpha: 1) ), outerColor:Color( #colorLiteral(red: 0.1882352941, green: 0.2039215686, blue: 0.2235294118, alpha: 0.9142765411) ))
                 CircleFull(radius: 64, fillColor: Color( #colorLiteral(red: 0.1768432284, green: 0.1971183778, blue: 0.2329204262, alpha: 1) ), forWidget: true, widgetType: .medium)
                 CircleSlice(radius: 64, endAngle: entry.endAngle, fillColor: Color( #colorLiteral(red: 0.426386714, green: 0.4582056999, blue: 0.4998273253, alpha: 1) ), whiteShadowOpacity: 0.1, forWidget: true, widgetType: .medium)
            }
        }
    }
    
    var largeView: some View{
        ZStack{
            if entry.isDaytime {
                BackgroundGradient(innerColor: Color( #colorLiteral(red: 0.8784313725, green: 0.7750043273, blue: 0.5811821818, alpha: 1) ), outerColor: Color( #colorLiteral(red: 0.9647058824, green: 0.7728223205, blue: 0.7040713429, alpha: 1) ))
                CircleFull(radius: 96, fillColor: Color( #colorLiteral(red: 0.5856760144, green: 0.3060674071, blue: 0.149171859, alpha: 0.1266320634) ), forWidget: true, widgetType: .large)
                CircleSlice(radius: 96, endAngle: entry.endAngle, fillColor:  Color( #colorLiteral(red: 0.9943665862, green: 0.9248313308, blue: 0.6853592992, alpha: 1) ), whiteShadowOpacity: 0.4, forWidget: true, widgetType: .large)
            }
            else {
                BackgroundGradient(innerColor: Color( #colorLiteral(red: 0.4169208705, green: 0.4877590537, blue: 0.6206590533, alpha: 1) ), outerColor:Color( #colorLiteral(red: 0.1882352941, green: 0.2039215686, blue: 0.2235294118, alpha: 0.9142765411) ))
                 CircleFull(radius: 96, fillColor: Color( #colorLiteral(red: 0.1768432284, green: 0.1971183778, blue: 0.2329204262, alpha: 1) ), forWidget: true, widgetType: .large)
                 CircleSlice(radius: 96, endAngle: entry.endAngle, fillColor: Color( #colorLiteral(red: 0.426386714, green: 0.4582056999, blue: 0.4998273253, alpha: 1) ), whiteShadowOpacity: 0.1, forWidget: true, widgetType: .large)
            }
        }
    }
}


struct DaylightWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            DaylightWidgetView(
                entry: DaylightEntry(
                    date: Date(),
                    isDaytime: true,
                    endAngle: Double.pi * 0.5
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            DaylightWidgetView(
                entry: DaylightEntry(
                    date: Date(),
                    isDaytime: true,
                    endAngle: Double.pi * 0.5
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            DaylightWidgetView(
                entry: DaylightEntry(
                    date: Date(),
                    isDaytime: true,
                    endAngle: Double.pi * 0.5
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

