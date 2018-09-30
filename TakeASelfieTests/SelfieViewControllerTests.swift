//
//  SelfieViewControllerTests.swift
//  TakeASelfieTests
//
//  Created by Abdullah Selek on 30.09.18.
//  Copyright © 2018 Abdullah Selek. All rights reserved.
//

import XCTest

@testable import TakeASelfie

class SelfieViewControllerTests: XCTestCase {

    var selfieViewController: SelfieViewController!
    let fakeSelfieViewDelegate = SelfieViewDelegateFake()

    override func setUp() {
        selfieViewController = SelfieViewController(withDelegate: fakeSelfieViewDelegate)
    }

    func testViewDidLoad() {
        _ = selfieViewController.view
        XCTAssertNotNil(selfieViewController.delegate)
    }

    override func tearDown() {
        selfieViewController = nil
    }

}

class SelfieViewDelegateFake: SelfieViewDelegate {

    func selfieViewControllerDismissed() {

    }

}
