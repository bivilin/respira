//
//  Round.swift
//  respira
//
//  Created by Beatriz Viseu Linhares on 18/08/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation

class Round {
    var roundDurationInSeconds: Int?
    private var respirationArray: [Respiration]

    init(roundDurationInSeconds: Int) {
        self.roundDurationInSeconds = 60
        self.respirationArray = [Respiration]()
    }

    func addRespirationToRound(respiration: Respiration) {
        self.respirationArray.append(respiration)
    }
}
