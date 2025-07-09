//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Hung Hoang Gia on 7/8/25.
//

import Foundation

class TriviaQuestionService {
    static func fetchTriviaQuestions(completion: @escaping (Result<[TriviaQuestion], Error>) -> Void) {
        let url = URL(string: "https://opentdb.com/api.php?amount=5")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                            DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                            return
                        }
            guard let data = data else {
                print("No Data")
                return
            }
            do {
                let decoder = JSONDecoder()
                let TriviaResponse = try decoder.decode(TriviaResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(TriviaResponse.results))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

