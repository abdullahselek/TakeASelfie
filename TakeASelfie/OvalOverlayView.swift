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
        overlayFrame = CGRect(x: (screenBounds.width - 300.0) / 2,
                              y: (screenBounds.height - 400.0) / 2,
                              width: 300.0,
                              height: 400.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let overlayPath = UIBezierPath(rect: bounds)
        let ovalPath = UIBezierPath(ovalIn: overlayFrame)
        overlayPath.append(ovalPath)
        overlayPath.usesEvenOddFillRule = true
        // draw oval layer
        let ovalLayer = CAShapeLayer()
        ovalLayer.path = ovalPath.cgPath
        ovalLayer.fillColor = UIColor.clear.cgColor
        ovalLayer.strokeColor = UIColor.green.cgColor
        ovalLayer.lineWidth = 5.0
        // draw layer that fills the view
        let fillLayer = CAShapeLayer()
        fillLayer.path = overlayPath.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor
        // add layers
        layer.addSublayer(fillLayer)
        layer.addSublayer(ovalLayer)
    }

}
