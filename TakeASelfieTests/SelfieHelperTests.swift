//
//  SelfieHelperTests.swift
//  TakeASelfieTests
//
//  Created by Abdullah Selek on 01.10.18.
//  Copyright © 2018 Abdullah Selek. All rights reserved.
//

import XCTest

@testable import TakeASelfie

class SelfieHelperTests: XCTestCase {

    func testOrientation() {
        XCTAssertEqual(SelfieHelper.orientation(orientation: .portraitUpsideDown), 8)
        XCTAssertEqual(SelfieHelper.orientation(orientation: .landscapeLeft), 3)
        XCTAssertEqual(SelfieHelper.orientation(orientation: .landscapeRight), 1)
        XCTAssertEqual(SelfieHelper.orientation(orientation: .portrait), 6)
    }

}
