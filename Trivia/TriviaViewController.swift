//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        questionContainerView.layer.cornerRadius = 8.0
        // TODO: FETCH TRIVIA QUESTIONS HERE
        TriviaQuestionService.fetchTriviaQuestions { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let questions):
                self.questions = questions
                self.currQuestionIndex = 0
                self.numCorrectQuestions = 0
                self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
            case .failure(let error):
                // Handle error (e.g., show an alert)
                print("Failed to fetch questions: \(error)")
        }
    }
  }
  
  private func updateQuestion(withQuestionIndex questionIndex: Int) {
    currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
    let question = questions[questionIndex]
    questionLabel.text = question.question
    categoryLabel.text = question.category
      // Combine correct and incorrect answers
         var answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()

         // Hide all answer buttons by default
         [answerButton0, answerButton1, answerButton2, answerButton3].forEach { $0?.isHidden = true }

         if question.type == "boolean" {
             // Force True/False answers
             answers = ["True", "False"].shuffled()
             answerButton0.setTitle(answers[0], for: .normal)
             answerButton1.setTitle(answers[1], for: .normal)
             answerButton0.isHidden = false
             answerButton1.isHidden = false
         } else {
             // Multiple choice (max 4 options)
             for (index, answer) in answers.enumerated() {
                 switch index {
                 case 0:
                     answerButton0.setTitle(answer.htmlDecoded, for: .normal)
                     answerButton0.isHidden = false
                 case 1:
                     answerButton1.setTitle(answer.htmlDecoded, for: .normal)
                     answerButton1.isHidden = false
                 case 2:
                     answerButton2.setTitle(answer.htmlDecoded, for: .normal)
                     answerButton2.isHidden = false
                 case 3:
                     answerButton3.setTitle(answer.htmlDecoded, for: .normal)
                     answerButton3.isHidden = false
                 default:
                     break
                 }
             }
         }
  }
  
  private func updateToNextQuestion(answer: String) {
    if isCorrectAnswer(answer) {
      numCorrectQuestions += 1
    }
    currQuestionIndex += 1
    guard currQuestionIndex < questions.count else {
      showFinalScore()
      return
    }
    updateQuestion(withQuestionIndex: currQuestionIndex)
  }
  
  private func isCorrectAnswer(_ answer: String) -> Bool {
    return answer == questions[currQuestionIndex].correctAnswer
  }
  
  private func showFinalScore() {
    let alertController = UIAlertController(title: "Game over!",
                                            message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                            preferredStyle: .alert)
    let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
      currQuestionIndex = 0
      numCorrectQuestions = 0
      updateQuestion(withQuestionIndex: currQuestionIndex)
    }
    alertController.addAction(resetAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
}

extension String {
    var htmlDecoded: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        return (try? NSAttributedString(data: data, options: options, documentAttributes: nil))?.string ?? self
    }
}
