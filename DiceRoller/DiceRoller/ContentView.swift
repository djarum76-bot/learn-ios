//
//  ContentView.swift
//  DiceRoller
//
//  Created by habil . on 27/12/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack{
            Form {
                Section{
                    Stepper(value: $viewModel.dice, in: 1...10) {
                        Text("Number of dice : \(viewModel.dice)")
                    }
                    
                    Picker("Select dice sided", selection: $viewModel.side) {
                        ForEach(viewModel.sides, id: \.self) { side in
                            Text("\(side)-sided")
                        }
                    }
                }
                
                Section{
                    NavigationLink("Play the game") {
                        SidedView().environmentObject(viewModel)
                    }
                }

            }
            .navigationTitle("Dice Roller")
            .toolbar{
                NavigationLink("History") {
                    HistoryView()
                        .environmentObject(viewModel)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
