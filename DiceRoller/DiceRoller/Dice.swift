//
//  Dice.swift
//  DiceRoller
//
//  Created by habil . on 27/12/23.
//

import Foundation

struct Dice{
    let sides: Int
    
    func roll() -> Int {
        return Int.random(in: 1...sides)
    }
}
