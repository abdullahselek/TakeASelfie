//
//  OvalOverlayViewTests.swift
//  TakeASelfieTests
//
//  Created by Abdullah Selek on 01.10.18.
//  Copyright © 2018 Abdullah Selek. All rights reserved.
//

import XCTest

@testable import TakeASelfie

class OvalOverlayViewTests: XCTestCase {

    func testInit() {
        let ovalOverlayView = OvalOverlayView()
        XCTAssertEqual(ovalOverlayView.backgroundColor, UIColor.clear)
    }

}
