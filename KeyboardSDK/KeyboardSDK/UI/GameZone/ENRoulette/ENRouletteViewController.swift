//
//  ENRouletteViewController.swift
//  KeyboardSDK
//
//  Created by Enliple on 2024/01/31.
//

import Foundation
import UIKit

public class ENRouletteViewController : UIViewController {
    lazy var spinWheelView = ENRouletteView(frame: .zero)
    lazy var btnSpin: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        btn.setTitle("돌리기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        
        btn.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
        
        return btn
    }()

    let itmes = [SpinWheelItemModel(text: "꽝", backgroundColor: .red, value: 1000),
                 SpinWheelItemModel(text: "1P", backgroundColor: .blue, value: 1000),
                 SpinWheelItemModel(text: "2P", backgroundColor: .green, value: 1000),
                 SpinWheelItemModel(text: "3P", backgroundColor: .brown, value: 1000)]
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(spinWheelView)
        self.view.addSubview(btnSpin)

        spinWheelView.delegate = self
        spinWheelView.items = itmes
        spinWheelView.ringImage = testRingImage()
        spinWheelView.ringLineWidth = 10

        spinWheelView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinWheelView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinWheelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        spinWheelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        spinWheelView.heightAnchor.constraint(equalTo: spinWheelView.widthAnchor, multiplier: 1.0).isActive = true
        spinWheelView.backgroundColor = .red
        spinWheelView.translatesAutoresizingMaskIntoConstraints = false

        
        btnSpin.translatesAutoresizingMaskIntoConstraints = false
        
        btnSpin.widthAnchor.constraint(equalToConstant: 120).isActive = true
        btnSpin.heightAnchor.constraint(equalToConstant: 50).isActive = true

        btnSpin.topAnchor.constraint(equalTo: spinWheelView.bottomAnchor, constant: 20).isActive = true
        btnSpin.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        btnSpin.addTarget(self, action: #selector(spin(_:)), for: .touchUpInside)

        self.view.backgroundColor = .white
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    @IBAction func spin(_ sender: Any) {
//        let index = indexPickerView.selectedRow(inComponent: 0)
//        print("spin wheel \(spinWheelView.items[index].text)")
//        spinWheelView.spinWheel(index)

        //여기 인덱스 값으로 룰렛 정지함
        let num = Int.random(in: 0..<spinWheelView.items.count)
        print("spin wheel num : \(num) >> \(spinWheelView.items[num].text)")
        spinWheelView.spinWheel(num)
    }
    func testRingImage() -> UIImage {
        let lineWidth: CGFloat = 10
        let width: CGFloat = spinWheelView.frame.width
        let height: CGFloat = spinWheelView.frame.height
        let center: CGPoint = CGPoint(x: width / 2, y: height / 2)
        
        let radius: CGFloat = min(width / 2, height / 2) - lineWidth / 2
        
        
        let ringLayer = CAShapeLayer()
        ringLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        ringLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: false).cgPath
        ringLayer.lineWidth = lineWidth
        ringLayer.strokeColor = UIColor.cyan.cgColor
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeStart = 0
        ringLayer.strokeEnd = 1
        ringLayer.setNeedsDisplay()
        
        let image = ringLayer.captureScreen()
        return image
    }

}
extension ENRouletteViewController: SpinWheelViewDelegate {
    func spinWheelWillStart(_ spinWheelView: ENRouletteView) {
        print("will start")
    }
    
    func spinWheelDidEnd(_ spinWheelView: ENRouletteView, at item: SpinWheelItemModel) {
        print("did end at \(item.text)")
    }
}
extension CALayer {

    func captureScreen() -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 300, height: 300), false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        self.render(in: ctx)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()
        let image = UIImage(cgImage: ctx.makeImage()!, scale: UIScreen.main.scale, orientation: outputImage.imageOrientation)
        return image
    }
}
