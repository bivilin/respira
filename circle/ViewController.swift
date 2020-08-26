//
//  ViewController.swift
//  circle
//
//  Created by Beatriz Viseu Linhares on 21/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//


import UIKit

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
        roundManager = RoundManager(minViewSize: 30, maxViewSize: 300, viewSizeRenderer: self)

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
                roundManager.startRound()
            }
        }

        if gesture.state == .ended {
            // Hapict Feeddback
            impact.impactOccurred()

            // Activates exhale
            roundManager.finishInhaling()
        }
    }

    // Stops circle movement
    @IBAction func stopButton(_ sender: Any) {
        // Stops timer
        if let roundManager = self.roundManager {
            roundManager.isBreathing = false
            roundManager.finishRoud()
        }
    }

}

extension ViewController: ViewSizeRenderer {
    func updateViewSize(newSize: Float) {
        let sizeInFloat = CGFloat(truncating: newSize as NSNumber)
        self.diameterContraint.constant = sizeInFloat
        self.circleView.layer.cornerRadius = self.diameterContraint.constant / 2
    }

    func resetViewSizeToMinimum(minimumSize: Float) {
        self.circleView.layoutIfNeeded() // force any pending operations to finish

        UIView.animate(withDuration: 1, animations: { () -> Void in
            self.diameterContraint.constant = CGFloat(minimumSize)
            self.circleView.layer.cornerRadius = self.diameterContraint.constant / 2
            self.view.layoutIfNeeded()
        })
    }

    func updateTimeDurationLabel(newDuration: Float) {
        let roundedDuration = Int(newDuration)
        let stringDuration = String(roundedDuration)
        self.durationLabel.text = stringDuration
    }

}
