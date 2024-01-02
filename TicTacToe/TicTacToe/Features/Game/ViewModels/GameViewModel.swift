//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by habil . on 01/01/24.
//

import Foundation

@MainActor class GameViewModel: ObservableObject{
    @Published var showingAlert = false
    @Published private(set) var alertTitle = ""
    @Published private(set) var alertMessage = ""
    
    @Published private(set) var gameState = GameState.initial
    @Published private(set) var gameTurnState = GameTurnState.playerOne
    
    @Published var gameTiles = [["", "", ""], ["", "", ""], ["", "", ""]]
    
    var isPlay: Bool {
        gameState == GameState.play
    }
    
    var isPlayerOneTurn: Bool {
        gameTurnState == GameTurnState.playerOne
    }
    
    var gameTile: String {
        if isPlayerOneTurn {
            "X"
        } else {
            "O"
        }
    }
    
    var gameTurn: GameTurnState {
        if isPlayerOneTurn {
            GameTurnState.playerTwo
        } else {
            GameTurnState.playerOne
        }
    }
    
    var isAllTilesFilled: Bool {
        for row in gameTiles {
            for element in row {
                if element.isEmpty {
                    return false
                }
            }
        }
        
        return true
    }
    
    func onTapTile(row: Int, column: Int){
        gameState = GameState.play
        
        if gameTiles[row][column].isEmpty {
            gameTiles[row][column] = gameTile
            
            if checkWin() {
                showingAlert = true
                alertTitle = "Game Over"
                alertMessage = isPlayerOneTurn ? "Player one win" : "Player two win"
            }
            
            if isAllTilesFilled {
                showingAlert = true
                alertTitle = "Game Over"
                
                if checkWin() {
                    alertMessage = isPlayerOneTurn ? "Player one win" : "Player two win"
                } else {
                    alertMessage = "No one win"
                }
            }
            
            gameTurnState = gameTurn
        }
    }
    
    func restartGame() {
        showingAlert = false
        alertTitle = ""
        alertMessage = ""
        
        gameState = GameState.initial
        gameTurnState = GameTurnState.playerOne
        
        gameTiles = [["", "", ""], ["", "", ""], ["", "", ""]]
    }
    
    private func checkWin() -> Bool {
        for i in 0...2 {
            if gameTiles[i][0] == gameTile && gameTiles[i][1] == gameTile && gameTiles[i][2] == gameTile {
                return true
            }
        }
        
        for i in 0...2 {
            if gameTiles[0][i] == gameTile && gameTiles[1][i] == gameTile && gameTiles[2][i] == gameTile {
                return true
            }
        }
        
        if gameTiles[0][0] == gameTile && gameTiles[1][1] == gameTile && gameTiles[2][2] == gameTile {
            return true;
        }
        
        if gameTiles[0][2] == gameTile && gameTiles[1][1] == gameTile && gameTiles[2][0] == gameTile {
            return true;
        }
        
        return false;
    }
}

extension GameViewModel{
    enum GameState{
        case initial, play, finish
    }
    
    enum GameTurnState{
        case playerOne, playerTwo
    }
}
