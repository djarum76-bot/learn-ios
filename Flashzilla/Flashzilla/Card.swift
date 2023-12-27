//
//  Card.swift
//  Flashzilla
//
//  Created by habil . on 27/12/23.
//

import Foundation

struct Card: Identifiable, Codable {
    let id: UUID
    let prompt: String
    let answer: String
    let isCorrect: Bool
    
    static let example = Card(id: UUID(), prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker", isCorrect: true)
}
