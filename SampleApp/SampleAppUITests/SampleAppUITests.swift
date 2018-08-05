//
//  SampleAppUITests.swift
//  SampleAppUITests
//
//  Created by Abdullah Selek on 03.08.18.
//  Copyright © 2018 Abdullah Selek. All rights reserved.
//

import XCTest

@testable import SampleApp

class SampleAppUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }

    func testOpenSelfieViewController() {
        let launchSdkButton = app.buttons["launchSdkButton"]
        XCTAssertNotNil(launchSdkButton)
        launchSdkButton.tap()
        addUIInterruptionMonitor(withDescription: "“SampleApp” Would Like to Access the Camera") { alert -> Bool in
            alert.buttons["OK"].tap()
            return true
        }
        let overlayView = app.windows.element(matching: .any, identifier: "takeASelfieOvalOverlayView")
        XCTAssertNotNil(overlayView)
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

}
