//
//  SidedView.swift
//  DiceRoller
//
//  Created by habil . on 27/12/23.
//

import SwiftUI

struct SidedView: View {
    @EnvironmentObject private var viewModel: ViewModel
    
    var body: some View {
        VStack{
            if !viewModel.diceResults.isEmpty {
                Text("Results: \(viewModel.diceResults.map { String($0) }.joined(separator: ", "))")
                    .padding()
            }
            
            Button("Roll Dice"){
                viewModel.rollDice()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    SidedView()
        .environmentObject(ViewModel())
}
