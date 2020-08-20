//
//  Respiration.swift
//  respira
//
//  Created by Beatriz Viseu Linhares on 18/08/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation

class Respiration {
    var respirationId: Int
    var inhaleDurationInSeconds: Int
    var exhaleDurationInSeconds: Int

    init(respirationId: Int, inhaleDurationInSeconds: Int, exhaleDurationInSeconds: Int) {
        self.respirationId = respirationId
        self.inhaleDurationInSeconds = inhaleDurationInSeconds
        self.exhaleDurationInSeconds = exhaleDurationInSeconds
    }
}
