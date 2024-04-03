//
//  ENScratchView.swift
//  KeyboardSDK
//
//  Created by Enliple on 2024/01/25.
//
import UIKit


@objc
public protocol ENScratchViewDelegate: AnyObject {
    
    func scratchCardEraseProgress(eraseProgress: Float)
}


 class ENScratchView:UIImageView {
    
    
    public weak var delegate: ENScratchViewDelegate?
    
    private var finalLocation: CGPoint?
    
    public lazy var lineType: CGLineCap = .round
    public lazy var lineWidth: CGFloat = 30.0
    
     override init(frame: CGRect) {
         super.init(frame: frame)
         print("game test init")
         
         isUserInteractionEnabled = true

     }
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
         
     }
     
    override public func awakeFromNib() {
        super.awakeFromNib()
        print("game test awakeFromNib")
        isUserInteractionEnabled = true
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("game test touchesBegan")

        guard  let touch = touches.first else {
            print("game test touchesBegan return")

            return
        }
        
        finalLocation = touch.location(in: self)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("game test touchesMoved ")

        guard  let touch = touches.first, let point = finalLocation else {
            print("game test touchesMoved return")

            return
        }
        
        let currentLocation = touch.location(in: self)
        scrachBetween(fromPoint: point, currentPoint: currentLocation)
        
        finalLocation = currentLocation
        
        
        if let img = self.image, let _ = delegate {
            let eraseProgress = scratchedPercentage(scratchImage: img)
            delegate?.scratchCardEraseProgress(eraseProgress: eraseProgress*100)
        }
    }
    
    func scrachBetween(fromPoint: CGPoint, currentPoint: CGPoint) {
        print("game test scrachBetween")

        UIGraphicsBeginImageContext(self.frame.size)
        
        image?.draw(in: self.bounds)
        
        let path = CGMutablePath()
        path.move(to: fromPoint)
        path.addLine(to: currentPoint)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(true)
        context.setLineCap(lineType)
        context.setLineWidth(lineWidth)
        context.setBlendMode(.clear)
        context.addPath(path)
        
        context.strokePath()
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext()
    }
    
    
    
    private func scratchedPercentage(scratchImage: UIImage) -> Float {
        print("game test scratchedPercentage")

        let width = Int(scratchImage.size.width)
        let height = Int(scratchImage.size.height)
        print("game test scratchedPercentage size :: \(scratchImage.size)")

        let bitmapBytesPerRow = width
        let bitmapByteCount = bitmapBytesPerRow * height
        
        let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: bitmapByteCount)
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        let context = CGContext(data: pixelData,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bitmapBytesPerRow,
                                space: colorSpace,
                                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.alphaOnly.rawValue).rawValue)!
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.clear(rect)
        context.draw(scratchImage.cgImage!, in: rect)
        
        var alphaOnlyPixels = 0
        
        for x in 0...Int(width) {
            for y in 0...Int(height) {
                
                if pixelData[y * width + x] == 0 {
                    alphaOnlyPixels += 1
                }
            }
        }
        
        free(pixelData)
        
        return Float(alphaOnlyPixels) / Float(bitmapByteCount)
    }
}

