//
//  GameView.swift
//  Wordle
//
//  Created by habil . on 02/01/24.
//

import SwiftUI

struct GameView: View {
    @StateObject private var gameVM = GameViewModel()
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 10){
                ForEach(0..<6, id: \.self) { index in
                    GameTextAnswer(answer: gameVM.historyAnswer[index])
                        .environmentObject(gameVM)
                }
                
                Divider()
                    .padding()
                    .padding(.horizontal, 40)
                
                GameTextField()
                    .environmentObject(gameVM)
                
                Button("Submit"){
                    gameVM.submitAnswer()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!gameVM.isAnswerValid)
            }
            .navigationTitle("Wordle")
            .alert(gameVM.alertTitle, isPresented: $gameVM.showingAlert){
                Button("Try again"){
                    gameVM.reset()
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
