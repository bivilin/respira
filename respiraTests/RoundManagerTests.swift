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
        XCTAssertEqual(roundManager?.minViewSize, 10)
        XCTAssertEqual(roundManager?.maxViewSize, 100)
        XCTAssertEqual(roundManager?.currentSize, 10)
    }

    func testDecreasingCircleTen() {
        let roundManager = RoundManager(minCircleSize: 10, maxCircleSize: 100)
        let newSize = roundManager.getNewViewSize(isInflating: false)
        XCTAssertEqual(newSize, 9.99)
    }

    func testIncreasingCircleTen() {
        let roundManager = RoundManager(minCircleSize: 10, maxCircleSize: 100)
        let newSize = roundManager.getNewViewSize(isInflating: true)
        XCTAssertEqual(Double(truncating: newSize as NSNumber),Double(10.05), accuracy:0.01)

    }

    func testIncreasingCircleFifty() {
        let roundManager = RoundManager(minCircleSize: 50, maxCircleSize: 100)
        let newSize = roundManager.getNewViewSize(isInflating: true)
        XCTAssertEqual(Double(truncating: newSize as NSNumber), 50.25, accuracy:0.01)
    }

    func testStartRoundIncreasesCircle() {
        let expectation = self.expectation(description: "Getting First New Size")
        var firstNewSize: Float = 0

        roundManager = RoundManager(minCircleSize: 50, maxCircleSize: 100)
        roundManager?.startRound { (newSize, newDuration) in
            self.roundManager?.finishRoud()
            firstNewSize = newSize
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10) { (error) in
            if error != nil {
                XCTFail("Erro: \(String(describing: error?.localizedDescription))")
            }
        }

        XCTAssertTrue(firstNewSize >= 50.0)
    }

    func testFinishRoundInvalidatesTimer() {
        roundManager = RoundManager(minCircleSize: 50, maxCircleSize: 100)
        roundManager?.startRound { (newSize, newDuration) in
        }
        self.roundManager?.finishRoud()
        let timerValidation = roundManager?.timer?.isValid
        XCTAssertEqual(timerValidation, false)

    }
}
