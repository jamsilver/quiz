//
//  ViewController.swift
//  Quiz
//
//  Created by James Silver on 09/05/2018.
//  Copyright © 2018 Silver Service. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var currentQuestionLabel: UILabel!
    @IBOutlet var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var answerLabel: UILabel!
    var questionSpacer: UILayoutGuide!
    @IBOutlet var nextQuestionButton: UIButton!
    
    let questions: [String] = [
        "What is 7+7?",
        "What is the capital of Vermont?",
        "What is cognac made from?",
        "A redunkulously long question string, a redunkulously long question string, a redunkulously long question string?"
    ]
    let answers: [String] = [
        "14",
        "Montpelier",
        "Grapes",
        "A redunkulously long answer string, a redunkulously long answer string, a redunkulously long answer string?"
    ]
    var currentQuestionIndex: Int = 0
    
    @IBAction func showAnswer(_ sender: UIButton) {
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentQuestionLabel.text = questions[currentQuestionIndex]
        
        // This spacer has right-side in the view center and
        // left-side, off-screen, one view-width to the left.
        questionSpacer = UILayoutGuide()
        view.addLayoutGuide(questionSpacer)
        questionSpacer.rightAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        questionSpacer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        questionSpacer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        questionSpacer.heightAnchor.constraint(equalToConstant: 0.0).isActive = true
        
        // Re-create the current/next CenterX anchors with
        // respect to the question spacer.
        resetQuestionLabelCentreXConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set the labels' initial alphas.
        currentQuestionLabel.alpha = 1
        nextQuestionLabel.alpha = 0
    }
    
    func resetQuestionLabelCentreXConstraints() {
        NSLayoutConstraint.deactivate([
            currentQuestionLabelCenterXConstraint,
            nextQuestionLabelCenterXConstraint
            ])
        currentQuestionLabelCenterXConstraint = currentQuestionLabel.centerXAnchor.constraint(
            equalTo: questionSpacer.rightAnchor
        )
        nextQuestionLabelCenterXConstraint = nextQuestionLabel.centerXAnchor.constraint(
            equalTo: questionSpacer.leftAnchor
        )
        NSLayoutConstraint.activate([
            currentQuestionLabelCenterXConstraint,
            nextQuestionLabelCenterXConstraint
            ])
    }
    
    @IBAction func showNextQuestion(_ sender: UIButton) {
        currentQuestionIndex += 1
        if (currentQuestionIndex == questions.count) {
            currentQuestionIndex = 0
        }
        let question: String = questions[currentQuestionIndex]
        nextQuestionLabel.text = question
        answerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    func animateLabelTransitions() {
        // Force any outstanding layout changes to occur.
        view.layoutIfNeeded()
        // Disable Next Question Button during animation.
        nextQuestionButton.isEnabled = false
        // Animate the alphas and the center X constaints.
        let screenWidth = view.frame.width
        self.nextQuestionLabelCenterXConstraint.constant += screenWidth
        self.currentQuestionLabelCenterXConstraint.constant += screenWidth
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {() -> Void in
                        self.currentQuestionLabel.alpha = 0
                        self.nextQuestionLabel.alpha = 1
                        self.view.layoutIfNeeded()
                       },
                       completion: { _ in
                        swap(&self.currentQuestionLabel,
                             &self.nextQuestionLabel)
                        swap(&self.currentQuestionLabelCenterXConstraint,
                             &self.nextQuestionLabelCenterXConstraint)
                        self.resetQuestionLabelCentreXConstraints()
                        self.nextQuestionButton.isEnabled = true
                       })
    }
}

