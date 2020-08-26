//
//  RoundManager.swift
//  respira
//
//  Created by Beatriz Viseu Linhares on 18/08/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation

protocol ViewSizeRenderer: class {
    func updateViewSize(newSize: Float)
    func resetViewSizeToMinimum(minimumSize: Float)
    func updateTimeDurationLabel(newDuration: Float)
}

class RoundManager {
    var minViewSize: Float
    var maxViewSize: Float
    var currentSize: Float
    var timer : Timer?
    var currentDurationInSeconds: Float?

    var isBreathing: Bool = false
    var isInflating: Bool = false

    weak var viewSizeRenderer: ViewSizeRenderer?

    init(minViewSize: Float, maxViewSize: Float, viewSizeRenderer: ViewSizeRenderer) {
        self.minViewSize = minViewSize
        self.maxViewSize = maxViewSize
        self.currentSize = Float(minViewSize)
        currentDurationInSeconds = 0
        self.viewSizeRenderer = viewSizeRenderer
    }

    func getNewViewSize(isInflating: Bool) -> Float {
        var sizeRate: Float = 1

        if isInflating {
            sizeRate = 1.005
        } else {
            sizeRate = 0.999
        }

        let newSize = self.currentSize * sizeRate
        return newSize
    }

    func startRound() {
        self.isBreathing = true
        self.isInflating = true

        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in

            // Updates Time Passed
            if let duration = self.currentDurationInSeconds {
                self.currentDurationInSeconds = duration + 0.01
            }

            // Saves New View Size
            self.currentSize = self.getNewViewSize(isInflating: self.isInflating)

            // Asks for UI to change the size
            self.viewSizeRenderer?.updateViewSize(newSize: self.currentSize)
            self.viewSizeRenderer?.updateTimeDurationLabel(newDuration: self.currentDurationInSeconds ?? 0)

        })
    }

    func finishRoud() {
        self.viewSizeRenderer?.resetViewSizeToMinimum(minimumSize: self.minViewSize)
        self.viewSizeRenderer?.updateTimeDurationLabel(newDuration: 0)
        self.currentSize = self.minViewSize
        self.timer?.invalidate()
    }

    func finishInhaling() {
        let inhaleDuration = self.currentDurationInSeconds
        self.currentDurationInSeconds = 0
        self.isInflating = false
        print("Inspirou por \(String(describing: inhaleDuration)) segundos.")
    }

    func finishExhaling() {
        let exhaleDuration = self.currentDurationInSeconds
        self.currentDurationInSeconds = 0
        self.isInflating = true
        print("Expirou por \(String(describing: exhaleDuration)) segundos.")
    }
}
