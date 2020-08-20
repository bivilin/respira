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

            if roundManager.isBreathing {
                // Future
            } else {
                // Starts breath session
                roundManager.isBreathing = true
                roundManager.startRound() { (newSize) in
                    // Updates circle size
                    self.diameterContraint.constant = CGFloat(newSize)
                    self.circleView.layer.cornerRadius = self.diameterContraint.constant / 2
                }
            }

            // Hapict Feeddback
            impact.impactOccurred()

            // Activates inhale
            roundManager.isInflating = true
        }

        if gesture.state == .ended {
            // Hapict Feeddback
            impact.impactOccurred()

            // Activates exhale
            roundManager.isInflating = false
        }
    }


    // Stops circle movement
    @IBAction func stopButton(_ sender: Any) {
        // Stops timer
        if let roundManager = self.roundManager {
            roundManager.timer?.invalidate()
        }
    }

}
