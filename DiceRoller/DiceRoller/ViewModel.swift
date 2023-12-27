//
//  ViewModel.swift
//  DiceRoller
//
//  Created by habil . on 27/12/23.
//

import Foundation

@MainActor class ViewModel: ObservableObject {
    @Published var dice = 1
    @Published var side = 4
    let sides = [4, 6, 8, 10, 12, 20, 100]
    let saveKey = "SavedData"
    
    @Published var diceResults = [Int]()
    @Published var historyResults = [[Int]]()
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([[Int]].self, from: data) {
                historyResults = decoded
                return
            }
        }
    }
    
    func rollDice() {
        var results: [Int] = []
        let selected = Dice(sides: side)
                
        for _ in 1...dice {
            results.append(selected.roll())
        }
                
        diceResults = results
        historyResults.append(diceResults)
        
        save()
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(historyResults) {
            UserDefaults.standard.setValue(encoded, forKey: saveKey)
        }
    }
}
