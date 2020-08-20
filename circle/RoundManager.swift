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
    var currentSize: Double
    var timer : Timer?

    var isBreathing: Bool = false
    var isInflating: Bool = false

    init(minCircleSize: Int, maxCircleSize: Int) {
        self.minCircleSize = minCircleSize
        self.maxCircleSize = maxCircleSize
        self.currentSize = Double(minCircleSize)
    }

    func updatesCircleSize(currentSize: Double, isInflating: Bool) -> Double {
        var sizeRate: Double = 1

        if isInflating {
            sizeRate = 1.005
        } else {
            sizeRate = 0.999
        }

        let newSize = currentSize * sizeRate
        return newSize
    }

    func startRound(completion: @escaping (Double) -> Void) {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
            var newSize: Double

            newSize = self.updatesCircleSize(currentSize: self.currentSize, isInflating: self.isInflating)
            self.currentSize = newSize

            completion(newSize)

        })
    }
}
