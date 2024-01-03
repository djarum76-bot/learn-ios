//
//  GameTextField.swift
//  Wordle
//
//  Created by habil . on 02/01/24.
//

import SwiftUI

struct GameTextField: View {
    @EnvironmentObject private var gameVM: GameViewModel
    @FocusState private var focus: Int?
    
    var body: some View {
        HStack{
            ForEach(0..<5, id: \.self) { index in
                TextField("", text: $gameVM.userAnswer[index], onEditingChanged: { editing in
                    if editing {
                        gameVM.oldText = gameVM.userAnswer[index]
                    }
                })
                .textInputAutocapitalization(.characters)
                .frame(width: 48, height: 48)
                .clipShape(.rect(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1)
                )
                .multilineTextAlignment(.center)
                .focused($focus, equals: index)
                .tag(index)
                .onChange(of: gameVM.userAnswer[index]) { oldValue, newValue in
                    if gameVM.userAnswer[index].count > 1 {
                        let currentValue = Array(gameVM.userAnswer[index])
                        
                        if currentValue[0] == Character(oldValue) {
                            gameVM.userAnswer[index] = String(gameVM.userAnswer[index].suffix(1))
                        } else {
                            gameVM.userAnswer[index] = String(gameVM.userAnswer[index].prefix(1))
                        }
                    }
                    
                    if !newValue.isEmpty {
                        if index == 4 {
                            focus = nil
                        } else {
                            focus = (focus ?? 0) + 1
                        }
                    } else {
                        focus = (focus ?? 0) - 1
                    }
                }
                .disabled(gameVM.isGameFinish)
            }
        }
    }
}

#Preview {
    GameTextField()
        .environmentObject(GameViewModel())
}
