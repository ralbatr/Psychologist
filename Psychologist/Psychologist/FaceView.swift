//
//  FaceView.swift
//  Happiness
//
//  Created by Ralbatr on 15/6/15.
//  Copyright (c) 2015年 ralbatr Yi. All rights reserved.
//

import UIKit

protocol FaceViewDataSource:class {
    func smilinessForFaceView(sender:FaceView) -> Double?
}

// 可使sb显示代码效果
@IBDesignable
class FaceView: UIView {
    @IBInspectable
    var lineWidth:CGFloat = 3 {
        didSet {
            // 这样每次改变线的宽度，系统都会重绘视图
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var scale: CGFloat = 0.90 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable
    var color:UIColor = UIColor.blueColor() {
        didSet {
            setNeedsDisplay()
        }
    }

    var faceCenter:CGPoint {
//        if #available(iOS 8.0, *) {
//            return convertPoint(center, fromCoordinateSpace: superview!)
//        } else {
            return CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
//        }
    }
    var faceRadius:CGFloat {
        return min(bounds.size.width, bounds.size.height)/2*scale
    }
    
    weak var dataSourece:FaceViewDataSource?
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRadio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRadio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRadio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRadio: CGFloat = 1
        static let FaceRadiusToMouthHeightRadio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRadio: CGFloat = 3
    }
    
    private enum Eye { case Left,Right }
    
    private func bezierPathForEye(whichEye:Eye) -> UIBezierPath
    {
        let eyeRadius = faceRadius/Scaling.FaceRadiusToEyeRadiusRadio
        let eyeVerticalOffset = faceRadius/Scaling.FaceRadiusToEyeOffsetRadio
        let eyeHorizontalSeparation = faceRadius/Scaling.FaceRadiusToEyeSeparationRadio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        
        switch whichEye {
        case .Left : eyeCenter.x -= eyeHorizontalSeparation/2
        case .Right: eyeCenter.x += eyeHorizontalSeparation/2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile:Double) -> UIBezierPath
    {
        let mouthWidth = faceRadius/Scaling.FaceRadiusToMouthWidthRadio
        let mouthHeight = faceRadius/Scaling.FaceRadiusToMouthHeightRadio
        let mouthVerticalOffset = faceRadius/Scaling.FaceRadiusToMouthOffsetRadio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1))*mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth/2, y: faceCenter.y + mouthVerticalOffset)
        
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth/3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth/3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        // 绘制曲线
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    func scale(gesture:UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle:CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        let smilness = dataSourece?.smilinessForFaceView(self) ?? 0.0
        bezierPathForSmile(smilness).stroke()
        
    }

}
