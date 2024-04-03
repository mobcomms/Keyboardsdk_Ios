//
//  ENTagView.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//

import UIKit
import KeyboardSDKCore


@IBDesignable
open class ENTagView: UIButton {

    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            tagLabel.layer.cornerRadius = cornerRadius
            tagLabel.layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            tagLabel.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var borderColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var textColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    @IBInspectable open var selectedTextColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    @IBInspectable open var titleLineBreakMode: NSLineBreakMode = .byTruncatingMiddle {
        didSet {
            tagLabel.lineBreakMode = titleLineBreakMode
        }
    }
    @IBInspectable open var paddingY: CGFloat = 2 {
        didSet {
            tagLabel.topInset = 0
            tagLabel.bottomInset = 0
            titleEdgeInsets.top = paddingY
            titleEdgeInsets.bottom = paddingY
        }
    }
    @IBInspectable open var paddingX: CGFloat = 5 {
        didSet {
            tagLabel.leftInset = 0
            tagLabel.rightInset = 0
            titleEdgeInsets.left = paddingX
            titleEdgeInsets.right = paddingX
        }
    }

    @IBInspectable open var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var highlightedBackgroundColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var selectedBorderColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var selectedBackgroundColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var textFont: UIFont = .systemFont(ofSize: 20.0, weight: .medium) {
        didSet {
            tagLabel.font = textFont
            titleLabel?.font = textFont
        }
    }
    
    private func reloadStyles() {
        if isHighlighted {
            if let highlightedBackgroundColor = highlightedBackgroundColor {
                // For highlighted, if it's nil, we should not fallback to backgroundColor.
                // Instead, we keep the current color.
                tagLabel.backgroundColor = highlightedBackgroundColor
            }
        }
        else if isSelected {
            tagLabel.backgroundColor = selectedBackgroundColor ?? tagBackgroundColor
            tagLabel.layer.borderColor = selectedBorderColor?.cgColor ?? borderColor?.cgColor
            tagLabel.textColor = selectedTextColor
        }
        else {
            tagLabel.backgroundColor = tagBackgroundColor
            tagLabel.layer.borderColor = borderColor?.cgColor
            tagLabel.textColor = textColor
        }
        
        setTitleColor(.clear, for: UIControl.State())
    }
    
    override open var isHighlighted: Bool {
        didSet {
            reloadStyles()
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            reloadStyles()
        }
    }
    
    // MARK: remove button
    
    let removeButton = ENCloseButton()
    let tagLabel:DHPaddedLabel = DHPaddedLabel()
    
    
    
    @IBInspectable open var enableRemoveButton: Bool = false {
        didSet {
            removeButton.isHidden = !enableRemoveButton
            updateRightInsets()
            
            if enableRemoveButton {
                shake()
            }
            else {
                stopShaking()
            }
        }
    }
    
    @IBInspectable open var removeButtonIconSize: CGFloat = 16 {
        didSet {
            removeButton.iconSize = removeButtonIconSize
            updateRightInsets()
        }
    }
    
    @IBInspectable open var removeIconLineWidth: CGFloat = 1.5 {
        didSet {
            removeButton.lineWidth = removeIconLineWidth
        }
    }
    @IBInspectable open var removeIconLineColor: UIColor = UIColor.white.withAlphaComponent(0.54) {
        didSet {
            removeButton.lineColor = removeIconLineColor
        }
    }
    
    /// Handles Tap (TouchUpInside)
    open var onTap: ((ENTagView) -> Void)?
    open var onLongPress: ((ENTagView) -> Void)?
    
    // MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public init(title: String) {
        super.init(frame: CGRect.zero)
        tagLabel.text = title
        setTitle(title, for: UIControl.State())
        
        setupView()
    }
    
    
    private func setupView() {
        tagLabel.lineBreakMode = titleLineBreakMode

        frame.size = intrinsicContentSize
        addSubview(tagLabel)
        addSubview(removeButton)
        removeButton.tagView = self
        
        var layoutConstraints:[NSLayoutConstraint] = []
        let views: [String: Any] = [
            "tagLabel": tagLabel
        ]
        
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[tagLabel]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[tagLabel]|", metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
        
        tagLabel.textAlignment = .center
        
        
        removeButton.layer.applyRounding(cornerRadius: 8.0, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
        removeButton.backgroundColor = UIColor.aikbdBasicTitleGray181
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        self.addGestureRecognizer(longPress)
        
        self.clipsToBounds = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(restartAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func longPress() {
        onLongPress?(self)
    }
    
    // MARK: - layout

    override open var intrinsicContentSize: CGSize {
        var size = titleLabel?.text?.size(withAttributes: [NSAttributedString.Key.font: textFont]) ?? CGSize.zero
        size.height = textFont.pointSize + paddingY * 2
        size.width += paddingX * 2
        if size.width < size.height {
            size.width = size.height
        }
        return size
    }
    
    private func updateRightInsets() {
        titleEdgeInsets.right = paddingX
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        removeButton.frame.size.width = removeButtonIconSize
        removeButton.frame.origin.x = self.frame.width - (removeButtonIconSize - 5)
        removeButton.frame.size.height = removeButtonIconSize
        removeButton.frame.origin.y = -5
        
        if enableRemoveButton {
            shake()
        }
        else {
            stopShaking()
        }
    }
    
    
    func shake() {
        stopShaking()
        
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 2
        shakeAnimation.autoreverses = true
        
        let startAngle: Float = (-1) * 3.14159/180 //(-2) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.15
        shakeAnimation.repeatCount = 10000
        shakeAnimation.timeOffset = 290 * drand48()

        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"shaking")
    }

    func stopShaking() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "shaking")
    }
    
    @objc func restartAnimation() {
        if enableRemoveButton {
            self.shake()
        }
        else {
            self.stopShaking()
        }
    }
}

/// Swift < 4.2 support
#if !(swift(>=4.2))
private extension NSAttributedString {
    typealias Key = NSAttributedStringKey
}
private extension UIControl {
    typealias State = UIControlState
}
#endif
