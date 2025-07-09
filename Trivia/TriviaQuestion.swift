//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaResponse: Decodable {
    let responseCode: Int
    let results: [TriviaQuestion]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
      }
}


struct TriviaQuestion: Decodable {
  let category: String
    let type: String
  let question: String
  let correctAnswer: String
  let incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case type
        case category
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
      }

}

