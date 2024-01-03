//
//  GameViewModel.swift
//  Wordle
//
//  Created by habil . on 02/01/24.
//

import Foundation
import UIKit

@MainActor class GameViewModel: ObservableObject{
    private var allAnswers: [String] = []
    
    @Published private(set) var realAnswer = ["S", "L", "I", "C", "E"]
    @Published private(set) var gameState = GameState.initial
    @Published var showingAlert = false
    @Published private(set) var alertTitle = ""
    @Published private(set) var alertMessage = ""
    
    //game text answer
    @Published private(set) var historyAnswer = ["", "", "", "", "", ""]
    @Published private(set) var position = 0
    
    //game text field
    @Published var userAnswer = Array(repeating: "", count: 5)
    @Published var oldText = ""
    
    var isQuotaExhausted: Bool {
        for answer in historyAnswer {
            if answer.isEmpty {
                return false
            }
        }
        
        return true
    }
    
    var isAnswerValid: Bool {
        for answer in userAnswer {
            if answer.isEmpty {
                return false
            }
        }
        
        return true
    }
    
    var isGetAnswer: Bool {
        realAnswer.elementsEqual(userAnswer)
    }
    
    var isGameFinish: Bool {
        gameState == GameState.finish
    }
    
    init(){
        if let startWordsURL = Bundle.main.url(forResource: "words", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                allAnswers = startWords.components(separatedBy: "\n")
                let word = allAnswers.randomElement() ?? "SLICE"
                realAnswer = word.map{ String($0) }
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    private func generateNewWord() -> [String] {
        let word = allAnswers.randomElement() ?? "SLICE"
        let answer = word.map{ String($0) }
        return answer
    }
    
    func submitAnswer(){
        if isAnswerValid && isReal(word: userAnswer.joined().lowercased()) && position < 6 {
            historyAnswer[position] = userAnswer.joined()
            position += 1
            
            if isGetAnswer {
                gameState = GameState.finish
                showingAlert = true
                alertTitle = "You Win"
                alertMessage = "You guessed the word in \(position) attempt"
                return
            }
        }
        
        if position > 5 {
            gameState = GameState.finish
            showingAlert = true
            alertTitle = "You Lose"
            alertMessage = "You can't guessed the word\nThe answer is \(realAnswer.joined())"
        }
        
        userAnswer = Array(repeating: "", count: 5)
    }
    
    func reset(){
        realAnswer = generateNewWord()
        gameState = GameState.initial
        showingAlert = false
        alertTitle = ""
        alertMessage = ""
        
        //game text answer
        historyAnswer = ["", "", "", "", "", ""]
        position = 0
        
        //game text field
        userAnswer = Array(repeating: "", count: 5)
        oldText = ""
    }
    
    private func isReal(word: String) -> Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
}

extension GameViewModel{
    enum GameState {
        case initial, play, finish
    }
}
