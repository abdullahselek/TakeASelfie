//
//  UIViewController+AlertTests.swift
//  TakeASelfieTests
//
//  Created by Abdullah Selek on 30.09.18.
//  Copyright © 2018 Abdullah Selek. All rights reserved.
//

import XCTest

@testable import TakeASelfie

class UIViewControllerAlertTests: XCTestCase {

    let viewController = AlertShowingViewController()

    func testShowAlertController() {
        let alertAction = UIAlertAction(title: "Action",
                                        style: .default,
                                        handler: nil)
        viewController.showAlertController(title: "Title",
                                           message: "Message",
                                           actions: [alertAction])
        XCTAssertTrue(viewController.isAlertDisplayed)
    }

}

class AlertShowingViewController: AlertControllerProtocol {

    var isAlertDisplayed = false

    func showAlertController(title: String?, message: String?, actions: [UIAlertAction]) {
        isAlertDisplayed = true
    }

}
