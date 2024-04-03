//
//  ENCloseButton.swift
//  TagListViewDemo
//
//  Created by Benjamin Wu on 2/11/16.
//  Copyright © 2016 Ela. All rights reserved.
//

import UIKit

internal class ENCloseButton: UIButton {

    var iconSize: CGFloat = 10
    var lineWidth: CGFloat = 1
    var lineColor: UIColor = UIColor.black.withAlphaComponent(0.54)

    weak var tagView: ENTagView?
    

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()

        path.lineWidth = lineWidth
        path.lineCapStyle = .round

        let size = iconSize - 10
        let iconFrame = CGRect(
            x: (rect.width - size) / 2.0,
            y: (rect.height - size) / 2.0,
            width: size,
            height: size
        )

        path.move(to: iconFrame.origin)
        path.addLine(to: CGPoint(x: iconFrame.maxX, y: iconFrame.maxY))
        path.move(to: CGPoint(x: iconFrame.maxX, y: iconFrame.minY))
        path.addLine(to: CGPoint(x: iconFrame.minX, y: iconFrame.maxY))

        lineColor.setStroke()

        path.stroke()
    }

}
