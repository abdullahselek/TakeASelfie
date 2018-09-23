//
//  OvalOverlayView.swift
//  TakeASelfie
//
//  Copyright © 2018 Abdullah Selek. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
