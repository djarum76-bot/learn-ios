//
//  GameBoard.swift
//  TicTacToe
//
//  Created by habil . on 01/01/24.
//

import SwiftUI

struct GameBoard: View {
    @EnvironmentObject private var gameVM: GameViewModel
    
    var body: some View {
        VStack(spacing: 0){
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 0){
                    ForEach(0..<3, id: \.self) { column in
                        ZStack(alignment: .center){
                            Rectangle()
                                .fill(.white)
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Rectangle()
                                        .stroke(.black, lineWidth: 1.0)
                                )
                            Text(gameVM.gameTiles[row][column])
                                .font(.largeTitle.bold())
                        }
                        .onTapGesture {
                            gameVM.onTapTile(row: row, column: column)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GameBoard()
        .environmentObject(GameViewModel())
}
