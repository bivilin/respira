//
//  ViewController.swift
//  circle
//
//  Created by Beatriz Viseu Linhares on 21/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

// TODO: expiração: círculo diminuindo quando tira o dedo -- state.ended do longpress

// TODO: definir o que acontece quando o usuário aperta de novo
//  --> círculo volta pro ponto inicial e começa a crescer de novo

// TODO: como visualizar meta da expiração?

// TODO: como salvar as respirações?
// Array de um struct?


import UIKit

//protocol SaveRespiration {
//    func addRespirationToRound(respiration: Respiration)
//}

class ViewController: UIViewController {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var diameterContraint: NSLayoutConstraint!
    @IBOutlet weak var durationLabel: UILabel!

    var roundManager: RoundManager?

    // Hapict Feeddback
    let impact = UIImpactFeedbackGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Creates RoundManager
        roundManager = RoundManager(minCircleSize: 30, maxCircleSize: 300)

        // Make view look like a circle
        self.circleView.layer.cornerRadius = self.diameterContraint.constant / 2

        // Gestures
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.view.addGestureRecognizer(longPress)
    }

    @objc func longPressed(gesture: UILongPressGestureRecognizer) {

        guard let roundManager = self.roundManager else {return}

        if gesture.state == .began {
            // Hapict Feeddback
            impact.impactOccurred()

            if roundManager.isBreathing {
                // Activates inhale
                roundManager.finishExhaling()
            } else {
                // Starts breath session
                roundManager.startRound() { (newSize, currentDuration) in
                    self.updateCircleSize(newSize: newSize)
                    self.updateTimeDurationLabel(newDuration: currentDuration)
                }
            }
        }

        if gesture.state == .ended {
            // Hapict Feeddback
            impact.impactOccurred()

            // Activates exhale
            roundManager.finishInhaling()
        }
    }

    func updateCircleSize(newSize: Double) {
        let sizeInFloat = CGFloat(newSize)
        self.diameterContraint.constant = sizeInFloat
        self.circleView.layer.cornerRadius = self.diameterContraint.constant / 2
    }

    func updateTimeDurationLabel(newDuration: Double) {
        let roundedDuration = Int(newDuration)
        let stringDuration = String(roundedDuration)
        self.durationLabel.text = stringDuration
    }

    // Stops circle movement
    @IBAction func stopButton(_ sender: Any) {
        // Stops timer
        if let roundManager = self.roundManager {
            roundManager.isBreathing = false
            roundManager.timer?.invalidate()
        }
    }

}
