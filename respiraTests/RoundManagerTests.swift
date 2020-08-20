//
//  RoundManagerTests.swift
//  respiraTests
//
//  Created by Beatriz Viseu Linhares on 20/08/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import XCTest

@testable import respira

class RoundManagerTests: XCTestCase {

    var roundManager: RoundManager?

    func testInitWorking() {
        roundManager = RoundManager(minCircleSize: 10, maxCircleSize: 100)
        XCTAssertEqual(roundManager?.minCircleSize, 10)
        XCTAssertEqual(roundManager?.maxCircleSize, 100)
        XCTAssertEqual(roundManager?.currentSize, 10)
    }

    func testDecreasingCircleTen() {
        let roundManager = RoundManager(minCircleSize: 10, maxCircleSize: 100)
        let newSize = roundManager.updatesCircleSize(isInflating: false)
        XCTAssertEqual(newSize, 9.99)
    }

    func testIncreasingCircleTen() {
        let roundManager = RoundManager(minCircleSize: 10, maxCircleSize: 100)
        let newSize = roundManager.updatesCircleSize(isInflating: true)
        XCTAssertEqual(newSize, 10.05)
        // Por que?
    }

    func testIncreasingCircleFifty() {
        let roundManager = RoundManager(minCircleSize: 50, maxCircleSize: 100)
        let newSize = roundManager.updatesCircleSize(isInflating: true)
        XCTAssertEqual(newSize, 50.25)
        // Por que?
    }

    func testStartRoundIncreasesCircle() {
        let expectation = self.expectation(description: "Getting First New Size")
        var firstNewSize: Double = 0
        var firstTime = true

        let roundManager = RoundManager(minCircleSize: 50, maxCircleSize: 100)
        roundManager.startRound { (newSize) in
            if firstTime {
                firstNewSize = newSize
                expectation.fulfill()
                firstTime = false
            }
        }

        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertTrue(firstNewSize >= 50.0)
    }
}
