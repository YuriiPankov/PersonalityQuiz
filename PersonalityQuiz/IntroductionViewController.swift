//
//  ViewController.swift
//  PersonalityQuiz
//
//  Created by Yurii Pankov on 12.05.2021.
//

import UIKit

class IntroductionViewController: UIViewController {

    @IBOutlet var beginQuizOneButton: UIButton!
    @IBOutlet var beginQuizTwoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToQuizIntroduction(segue: UIStoryboardSegue){
        
    }
    @IBAction func beginQuizOne(_ sender: Any) {
        performSegue(withIdentifier: "beginQuizSegue", sender: beginQuizOneButton)
    }
    
    @IBAction func beginQuizTwo(_ sender: UIButton) {
        performSegue(withIdentifier: "beginQuizSegue", sender: beginQuizTwoButton)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? UIButton else {
            return
        }
        
        guard let destination = segue.destination as? QuestionViewController else {
            return
        }
        
        if sender == beginQuizOneButton {
            destination.questions = destination.questionsOne
        } else if sender == beginQuizTwoButton {
            destination.questions = destination.questionsTwo
        }
    }
}

