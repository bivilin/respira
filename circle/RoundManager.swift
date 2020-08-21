//
//  RoundManager.swift
//  respira
//
//  Created by Beatriz Viseu Linhares on 18/08/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation

class RoundManager {
    var minCircleSize: Int
    var maxCircleSize: Int
    var currentSize: Decimal
    var timer : Timer?
    var currentDurationInSeconds: Decimal?

    var isBreathing: Bool = false
    var isInflating: Bool = false

    init(minCircleSize: Int, maxCircleSize: Int) {
        self.minCircleSize = minCircleSize
        self.maxCircleSize = maxCircleSize
        self.currentSize = Decimal(minCircleSize)
        currentDurationInSeconds = 0
    }

    func updatesCircleSize(isInflating: Bool) -> Decimal {
        var sizeRate: Decimal = 1

        if isInflating {
            sizeRate = 1.005
        } else {
            sizeRate = 0.999
        }

        let newSize = self.currentSize * sizeRate
        return newSize
    }

    func startRound(completion: @escaping (Decimal, Decimal) -> Void) {
        self.isBreathing = true
        self.isInflating = true

        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in

            // Updates Time Passed
            if let duration = self.currentDurationInSeconds {
                self.currentDurationInSeconds = duration + 0.01
            }

            // Updates Current Size for Circle
            self.currentSize = self.updatesCircleSize(isInflating: self.isInflating)

            // Sends new values to UI
            completion(self.currentSize, self.currentDurationInSeconds ?? 0)

        })
    }

    func finishRoud() {
        self.timer?.invalidate()
    }

    func finishInhaling() {
        let inhaleDuration = self.currentDurationInSeconds
        self.currentDurationInSeconds = 0
        self.isInflating = false
        print("Inspirou por \(inhaleDuration) segundos.")
    }

    func finishExhaling() {
        let exhaleDuration = self.currentDurationInSeconds
        self.currentDurationInSeconds = 0
        self.isInflating = true
        print("Expirou por \(exhaleDuration) segundos.")
    }
}
