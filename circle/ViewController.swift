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

class ViewController: UIViewController {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var diameterContraint: NSLayoutConstraint!
    @IBOutlet weak var goalCircle: UIView!
    @IBOutlet weak var buttonBackground: UIView!
    @IBOutlet weak var buttonText: UIButton!

    // Timer
    @IBOutlet weak var timeLabel: UILabel!

    var timer : Timer!
    var time: Double = 0.0
    var outputRespiration: String = ""
    var respirationRound: Int = 0

    // Hapict Feeddback
    let impact = UIImpactFeedbackGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.buttonBackground.layer.cornerRadius = self.buttonBackground.layer.cornerRadius / 1.5
        buttonText.titleLabel?.text = "concluir"

        timeLabel.text = ""
        // Transformando views em círculos
        self.myView.layer.cornerRadius = self.diameterContraint.constant / 2
        //self.goalCircle.layer.cornerRadius = 150

        // Gestures
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.view.addGestureRecognizer(longPress)
    }

    @objc func longPressed(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // Hapict Feeddback
            impact.impactOccurred()
            // Turn off timer in case there's one currently running
            if let timer = self.timer {
                outputRespiration += "E: \(String(format: "%.0f", self.time)) sec "
                timer.invalidate()
            }

            time = 0
            resetAnimation()
            respirationRound += 1

            // Creates timer for inhale
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
                self.time += 0.01
                print("inhale")
                //self.diameterContraint.constant = CGFloat(300 * self.time / 8)
                if self.diameterContraint.constant < 300 {
                    self.diameterContraint.constant = self.diameterContraint.constant * 1.003
                }
                print(self.diameterContraint.constant)
                self.myView.layer.cornerRadius = self.diameterContraint.constant / 2
                self.timeLabel.text = String(format: "%.0f", self.time)
            })
        }
        // Funciona só se o usuário tiver alcançado a meta de inspiração
        if gesture.state == .ended {
            // Hapict Feeddback
            impact.impactOccurred()
            outputRespiration += "\n Respiração \(respirationRound) \n I: \(String(format: "%.0f", self.time)) sec | "
            time = 0
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
                self.time += 0.01
                print("exhale")
                //self.diameterContraint.constant = CGFloat(300 - (300 - 30) / 8 * self.time)
                self.diameterContraint.constant = self.diameterContraint.constant * 0.999
                print(self.diameterContraint.constant)
                self.myView.layer.cornerRadius = self.diameterContraint.constant / 2
                self.timeLabel.text = String(format: "%.0f", self.time)
            })
        }
    }
    @IBAction func stopButton(_ sender: Any) {
        timer.invalidate()
        print(outputRespiration)
        let alert = UIAlertController(title: "Resumo da respiração", message: outputRespiration, preferredStyle: .actionSheet)
        let okAction = UIAlertAction (title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion:  nil)
        resetData()
    }

    private func resetData() {
        time = 0.0
        outputRespiration = ""
        respirationRound = 0
        resetAnimation()
    }

    private func resetAnimation() {
        self.diameterContraint.constant = 30
        self.myView.layer.cornerRadius = self.diameterContraint.constant / 2
    }

}
