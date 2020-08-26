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

    // Changing this value allows circle inflation/deflation
    @IBOutlet weak var diameterContraint: NSLayoutConstraint!

    // End Button
    @IBOutlet weak var buttonBackground: UIView!
    @IBOutlet weak var buttonText: UIButton!

    // Breathe Duration Label
    @IBOutlet weak var timeLabel: UILabel!

    var timer : Timer?
    var time: Double = 0.0

    var roundManager = RoundManager(minCircleSize: 30, maxCircleSize: 300)

    // String to be outputed by the end of the Round
//    var outputRespiration: String = ""
    var respirationId: Int = 0

    // Hapict Feeddback
    let impact = UIImpactFeedbackGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Visual design for button
//        self.buttonBackground.layer.cornerRadius = self.buttonBackground.layer.cornerRadius / 1.5

        //Button Text
//        buttonText.titleLabel?.text = "concluir"

        // Make view look like a circle
        self.circleView.layer.cornerRadius = self.diameterContraint.constant / 2

        // Idle Setup
        timeLabel.text = ""

        // Gestures
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.view.addGestureRecognizer(longPress)
    }

    @objc func longPressed(gesture: UILongPressGestureRecognizer) {

        if gesture.state == .began {

            if roundManager.isBreathing {
                //saveRespiration()
                time = 0
            } else {
                roundManager.isBreathing = true
                roundManager.startRound() { (newSize) in
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


    @IBAction func stopButton(_ sender: Any) {
        timer?.invalidate()
//        print(outputRespiration)
//        let alert = UIAlertController(title: "Resumo da respiração", message: outputRespiration, preferredStyle: .alert)
//        self.present(alert, animated: true, completion:  nil)
    }

}
