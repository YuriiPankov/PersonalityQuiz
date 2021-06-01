//
//  QuestionViewController.swift
//  PersonalityQuiz
//
//  Created by Yurii Pankov on 22.05.2021.
//

import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButton1: UIButton!
    @IBOutlet var singleButton2: UIButton!
    @IBOutlet var singleButton3: UIButton!
    @IBOutlet var singleButton4: UIButton!
    
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabel1: UILabel!
    @IBOutlet var multipleLabel2: UILabel!
    @IBOutlet var multipleLabel3: UILabel!
    @IBOutlet var multipleLabel4: UILabel!
    @IBOutlet var multiSwitch1: UISwitch!
    @IBOutlet var multiSwitch2: UISwitch!
    @IBOutlet var multiSwitch3: UISwitch!
    @IBOutlet var multiSwitch4: UISwitch!
            
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedLabel1: UILabel!
    @IBOutlet var rangedLabel2: UILabel!
    @IBOutlet var rangedSlider: UISlider!
    
    
    @IBOutlet var questionProgressView: UIProgressView!
    
    
    var questions: [Question] = []
    
    var questionsOne: [Question] = [
        
        
        Question(text: "ONE: Which activities do you enjoy?", type: .multiple, answers: [
            Answer(text: "Swimming", type: .turtle),
            Answer(text: "Sleeping", type: .cat),
            Answer(text: "Cuddling", type: .rabbit),
            Answer(text: "Eating", type: .dog)
        ]),
        
        Question(text: "ONE: Which food do you like most?", type: .single, answers: [
            Answer(text: "Steak", type: .dog),
            Answer(text: "Fish", type: .cat),
            Answer(text: "Carrots", type: .rabbit),
            Answer(text: "Corn", type: .turtle)
        ]),
        
        Question(text: "ONE: How much do you enjoy car rides?", type: .ranged, answers: [
            Answer(text: "I dislike them", type: .cat),
            Answer(text: "I get a little nervous", type: .rabbit),
            Answer(text: "I barely notice them", type: .turtle),
            Answer(text: "I love them", type: .dog)
        ])
    
    ]
    
    var questionsTwo: [Question] = [
        
        
        Question(text: "TWO: Which activities do you enjoy?", type: .multiple, answers: [
            Answer(text: "Swimming", type: .turtle),
            Answer(text: "Sleeping", type: .cat),
            Answer(text: "Cuddling", type: .rabbit),
            Answer(text: "Eating", type: .dog)
        ]),
        
        Question(text: "TWO: Which food do you like most?", type: .single, answers: [
            Answer(text: "Steak", type: .dog),
            Answer(text: "Fish", type: .cat),
            Answer(text: "Carrots", type: .rabbit),
            Answer(text: "Corn", type: .turtle)
        ]),
        
        Question(text: "TWO: How much do you enjoy car rides?", type: .ranged, answers: [
            Answer(text: "I dislike them", type: .cat),
            Answer(text: "I get a little nervous", type: .rabbit),
            Answer(text: "I barely notice them", type: .turtle),
            Answer(text: "I love them", type: .dog)
        ])
    
    ]
    
    
    var questionIndex = Int.random(in: 0...2)
    
    var arrayOfQuestionIndexes: [Int] = []
    
    var answersChosen: [Answer] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        singleButton1.addTarget(self, action: #selector(singleAnswerButtonPressed(_:)), for: .touchUpInside)
        singleButton2.addTarget(self, action: #selector(singleAnswerButtonPressed(_:)), for: .touchUpInside)
        singleButton3.addTarget(self, action: #selector(singleAnswerButtonPressed(_:)), for: .touchUpInside)
        singleButton4.addTarget(self, action: #selector(singleAnswerButtonPressed(_:)), for: .touchUpInside)
    }
    
    
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        
        let currentAnswer = questions[questionIndex].answers
        
        switch sender {
        case singleButton1:
            answersChosen.append(currentAnswer[0])
        case singleButton2:
            answersChosen.append(currentAnswer[1])
        case singleButton3:
            answersChosen.append(currentAnswer[2])
        case singleButton4:
            answersChosen.append(currentAnswer[3])
        default:
            break
        }
        
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        
        let currentAnswers = questions[questionIndex].answers
        
        if multiSwitch1.isOn {
            answersChosen.append(currentAnswers[0])
        }
        if multiSwitch2.isOn {
            answersChosen.append(currentAnswers[1])
        }
        if multiSwitch3.isOn {
            answersChosen.append(currentAnswers[2])
        }
        if multiSwitch4.isOn {
            answersChosen.append(currentAnswers[3])
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        let index = Int(round(rangedSlider.value * Float(currentAnswers.count - 1)))
        
        answersChosen.append(currentAnswers[index])
        
        nextQuestion()
    }
    
    
    func nextQuestion(){
        arrayOfQuestionIndexes.append(questionIndex)
        
        if arrayOfQuestionIndexes.count < questions.count {
            
            repeat {
                questionIndex = Int.random(in: 0..<questions.count)
            } while arrayOfQuestionIndexes.contains(questionIndex)
            
            updateUI()
        } else {
            performSegue(withIdentifier: "Results", sender: nil)
            arrayOfQuestionIndexes.removeAll()
        }
    }
    
    @IBSegueAction func showResults(_ coder: NSCoder) -> ResultsViewController? {
        return ResultsViewController(coder: coder, responses: answersChosen)
    }
    
    
    func updateUI()  {
        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        
        navigationItem.title = "Question #\(questionIndex + 1)"
        
        let currentQuestion = questions[questionIndex]
        let currentAnswer = currentQuestion.answers
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        switch currentQuestion.type {
        case .single:
            updateSingleStack(using: currentAnswer)
        case .multiple:
            updateMultipleStack(using: currentAnswer)
        case .ranged:
            updateRangeStack(using: currentAnswer)
        }
        
        questionLabel.text = currentQuestion.text
        questionProgressView.setProgress(totalProgress, animated: true)
        
    }
    
    func updateSingleStack(using answers: [Answer]) {
        let randomArrayOfIndexes = randomAnswerOrder()
        singleStackView.isHidden = false
//        singleButton1.isHidden = Bool.random()
        singleButton1.setTitle(answers[randomArrayOfIndexes[0]].text, for: .normal)
        singleButton2.setTitle(answers[randomArrayOfIndexes[1]].text, for: .normal)
        singleButton3.setTitle(answers[randomArrayOfIndexes[2]].text, for: .normal)
        singleButton4.setTitle(answers[randomArrayOfIndexes[3]].text, for: .normal)
    }
    
    func updateMultipleStack(using answers: [Answer]) {
        let randomArrayOfIndexes = randomAnswerOrder()
        multipleStackView.isHidden = false
        multiSwitch1.isOn = false
        multiSwitch2.isOn = false
        multiSwitch3.isOn = false
        multiSwitch4.isOn = false
        multipleLabel1.text = answers[randomArrayOfIndexes[0]].text
        multipleLabel2.text = answers[randomArrayOfIndexes[1]].text
        multipleLabel3.text = answers[randomArrayOfIndexes[2]].text
        multipleLabel4.text = answers[randomArrayOfIndexes[3]].text
    }
    
    func updateRangeStack(using answers: [Answer]) {
        rangedStackView.isHidden = false
        rangedSlider.setValue(0.5, animated: false)
        rangedLabel1.text = answers.first?.text
        rangedLabel2.text = answers.last?.text
    }
        
    func randomAnswerOrder() -> [Int] {
        var arrayOfRandomIndexes: [Int] = []
        var index: Int
        for _ in 0...3 {
            repeat {
                index = Int.random(in: 0...3)
            } while arrayOfRandomIndexes.contains(index)
            arrayOfRandomIndexes.append(index)
        }
        return arrayOfRandomIndexes
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
