//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Ralbatr on 15/6/15.
//  Copyright (c) 2015年 ralbatr Yi. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController ,FaceViewDataSource {

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSourece = self
            // 放大缩小手势
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
            // 滑动手势
//            faceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: <#T##Selector#>))
        }
    }
    var happiness: Int = 100 { // 0 = very sad 非常悲伤,100 = ecstatic 非常高兴
        didSet {
            happiness = min(max(happiness, 0) ,100)
            print("happiness = \(happiness)")
            updateUI()
        }
    }
    
    private struct Constants {
        static let HappinessGestureScale:CGFloat = 4.0
    }
    
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default :break
        }
    }
    private func updateUI()
    {
        faceView.setNeedsDisplay()
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50)/50
    }

}
