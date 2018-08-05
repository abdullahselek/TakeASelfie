//
//  OvalOverlayView.swift
//  TakeASelfie
//
//  Created by Abdullah Selek on 04.08.18.
//  Copyright © 2018 Abdullah Selek. All rights reserved.
//

import UIKit

internal class OvalOverlayView: UIView {

    let screenBounds = UIScreen.main.bounds
    var overlayFrame: CGRect!

    internal init() {
        super.init(frame: screenBounds)
        backgroundColor = UIColor.clear
        accessibilityIdentifier = "takeASelfieOvalOverlayView"
        overlayFrame = CGRect(x: (screenBounds.width - 300.0) / 2 , y: (screenBounds.height - 400.0) / 2, width: 300.0, height: 400.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let ellipsePath = UIBezierPath(ovalIn: overlayFrame)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = ellipsePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 5.0
        self.layer.addSublayer(shapeLayer)
    }

}
