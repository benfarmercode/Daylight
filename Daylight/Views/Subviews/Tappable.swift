//
//  Tappable.swift
//  Daylight
//
//  Created by Ben Farmer on 6/4/21.
//

import SwiftUI

struct TappableView:UIViewRepresentable {
    var tappedCallback: ((CGPoint, Int) -> Void)
    
    func makeUIView(context: UIViewRepresentableContext<TappableView>) -> UIView {
        let v = UIView(frame: .zero)
        let gesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tapped))
        gesture.numberOfTapsRequired = 1
//        let gesture2 = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.doubleTapped))
//        gesture2.numberOfTapsRequired = 2
//        gesture.require(toFail: gesture2)
        v.addGestureRecognizer(gesture)
//        v.addGestureRecognizer(gesture2)
        return v
    }
    
    class Coordinator: NSObject {
        var tappedCallback: ((CGPoint, Int) -> Void)
        init(tappedCallback: @escaping ((CGPoint, Int) -> Void)) {
            self.tappedCallback = tappedCallback
        }
        @objc func tapped(gesture:UITapGestureRecognizer) {
            let point = gesture.location(in: gesture.view)
            self.tappedCallback(point, 1)
        }
        @objc func doubleTapped(gesture:UITapGestureRecognizer) {
            let point = gesture.location(in: gesture.view)
            self.tappedCallback(point, 2)
        }
    }
    
    func makeCoordinator() -> TappableView.Coordinator {
        return Coordinator(tappedCallback:self.tappedCallback)
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<TappableView>) {
    }
    
}
