//
//  GameTextAnswer.swift
//  Wordle
//
//  Created by habil . on 02/01/24.
//

import SwiftUI

struct GameTextAnswer: View {
    private let answer: [String]
    @EnvironmentObject private var gameVM: GameViewModel
    
    init(answer: String) {
        self.answer = answer.isEmpty ? Array(repeating: "", count: 5) : answer.map { String($0) }
    }
    
    var body: some View {
        HStack{
            ForEach(0..<5, id: \.self){ index in
                ZStack{
                    Rectangle()
                        .frame(width: 48, height: 48)
                        .foregroundStyle(boxColor(character: answer[index], index: index))
                        .clipShape(.rect(cornerRadius: 5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: answer[index].isEmpty ? 1 : 0)
                        )
                        .multilineTextAlignment(.center)
                    
                    Text(answer[index])
                        .bold()
                        .foregroundStyle(answer[index].isEmpty ? .black : .white)
                }
            }
        }
    }
    
    private func boxColor(character: String, index: Int) -> Color {
        if character.isEmpty {
            return .white
        } else {
            if gameVM.realAnswer.contains(character) {
                if gameVM.realAnswer[index] == character {
                    return .green
                } else {
                    return .yellow
                }
            } else {
                return .gray
            }
        }
    }
}

#Preview {
    GameTextAnswer(answer: "SLCIE")
        .environmentObject(GameViewModel())
}
