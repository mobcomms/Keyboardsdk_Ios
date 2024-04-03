//
//  DHColorPicker.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/06/17.
//

import Foundation
import UIKit



internal protocol DHColorPickerDelegate : NSObjectProtocol {
    func DHColorColorPickerTouched(sender:DHColorPicker, color:UIColor, point:CGPoint, state:UIGestureRecognizer.State)
}

@IBDesignable
class DHColorPicker : UIView {

    weak internal var delegate: DHColorPickerDelegate?
    let saturationExponentTop:Float = 2.0
    let saturationExponentBottom:Float = 1.3

    @IBInspectable var elementSize: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    let pointView:UIView = UIView()
    let shadow = UIView()

    private func initialize() {
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        
        self.addGestureRecognizer(touchGesture)
        
        
        shadow.backgroundColor = UIColor.init(white: 1.0, alpha: 0.1)
        shadow.layer.applyRounding(cornerRadius: 11, borderColor: .white, borderWidth: 2.0, masksToBounds: true)
//        let shadow2 = UIView()
//        shadow2.backgroundColor = .clear
//        shadow2.layer.applyRounding(cornerRadius: 6.5, borderColor: .black, borderWidth: 1.0, masksToBounds: true)
        
        pointView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        pointView.backgroundColor = .clear
        pointView.clipsToBounds = false
        pointView.layer.applySketchShadow(color: .black, alpha: 0.2, x: 0, y: 1, blur: 2, spread: 0)
        
        shadow.frame = pointView.bounds
        pointView.addSubview(shadow)
        
//        shadow2.frame = CGRect.init(x: 1, y: 1, width: pointView.bounds.width-2, height: pointView.bounds.height-2)
//        pointView.addSubview(shadow2)
        
        self.addSubview(pointView)
        pointView.isHidden = true
    }

   override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        for y : CGFloat in stride(from: 0.0 ,to: rect.height, by: elementSize) {
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
            for x : CGFloat in stride(from: 0.0 ,to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
    }

    func getColorAtPoint(point:CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                               y:elementSize * CGFloat(Int(point.y / elementSize)))
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
        : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

    func getPointForColor(color:UIColor) -> CGPoint {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);

        var yPos:CGFloat = 0
        let halfHeight = (self.bounds.height / 2)
        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
            yPos = CGFloat(percentageY) * halfHeight
        } else {
            //use brightness to get Y
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }
        let xPos = hue * self.bounds.width
        return CGPoint(x: xPos, y: yPos)
    }

    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {

        if (gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed) {
            var point = gestureRecognizer.location(in: self)
            if point.x < 0 {
                point.x = 0
            }
            if point.x > self.bounds.width {
                point.x = self.bounds.width
            }
            if point.y < 0 {
                point.y = 0
            }
            if point.y > self.bounds.height {
                point.y = self.bounds.height
            }
            
            let color = getColorAtPoint(point: point)
            self.delegate?.DHColorColorPickerTouched(sender: self, color: color, point: point, state:gestureRecognizer.state)
            
            pointView.isHidden = false
            shadow.layer.applyRounding(cornerRadius: 11, borderColor: (color.isLight() ? .black : .white), borderWidth: 2.0, masksToBounds: true)
            
            updatePointViewPosition(at: point)
        }
    }
    
    public func updatePointViewPosition(at color:UIColor) {
        let point = getPointForColor(color: color)
        pointView.center = point
    }
    
    public func updatePointViewPosition(at point:CGPoint) {
        pointView.center = point
    }
        
    public func initPointView() {
        pointView.isHidden = true
    }
}
