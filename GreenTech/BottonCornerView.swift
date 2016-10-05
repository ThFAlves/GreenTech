//
//  BottonCornerView.swift
//  GreenTech
//
//  Created by Leonardo Maffei on 05/10/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit

class BottonCornerView: UIView {

    public var color = UIColor.clear

    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        
        layer.mask = shapeLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = shapeLayer.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = 2
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
}
