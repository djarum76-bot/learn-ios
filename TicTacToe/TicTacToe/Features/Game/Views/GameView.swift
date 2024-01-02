//
//  GameView.swift
//  TicTacToe
//
//  Created by habil . on 01/01/24.
//

import SwiftUI

struct GameView: View {
    @StateObject private var gameVM = GameViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                
                GameBoard()
                    .environmentObject(gameVM)
                
                Spacer()
                
                if gameVM.isPlay {
                    Button("Restart"){
                        gameVM.restartGame()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Tic-Tac-Toe")
            .alert(gameVM.alertTitle, isPresented: $gameVM.showingAlert){
                Button("Try again"){
                    gameVM.restartGame()
                }
            } message: {
                Text(gameVM.alertMessage)
            }
        }
    }
}

#Preview {
    GameView()
}
