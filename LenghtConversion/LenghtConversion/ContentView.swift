//
//  ContentView.swift
//  LenghtConversion
//
//  Created by habil . on 17/12/23.
//

import SwiftUI

struct ContentView: View {
    @FocusState private var inputIsFocused: Bool
    @State private var selectedInputUnit: String = "meters"
    @State private var selectedOutputUnit: String = "meters"
    @State private var totalInput: Double = 0.0
    var totalOutput: Double {
        var result: Double = totalInput

        if selectedInputUnit == selectedOutputUnit {
            return result
        }

        switch (selectedInputUnit, selectedOutputUnit) {
            case ("kilometers", "meters"):
                result *= 1000
            case ("meters", "kilometers"):
                result /= 1000
            case ("feet", "meters"):
                result *= 0.3048
            case ("meters", "feet"):
                result /= 0.3048
            case ("yard", "meters"):
                result *= 0.9144
            case ("meters", "yard"):
                result /= 0.9144
            case ("miles", "meters"):
                result *= 1609.34
            case ("meters", "miles"):
                result /= 1609.34
            default:
                break
            }

        return result
    }

    
    let units = ["meters", "kilometers", "feet", "yard", "miles"]
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    Picker("Input Unit", selection: $selectedInputUnit){
                        ForEach(units, id:\.self){
                            Text($0)
                        }
                    }
                    
                    Picker("Output Unit", selection: $selectedOutputUnit){
                        ForEach(units, id:\.self){
                            Text($0)
                        }
                    }
                }
                
                Section("Type your input here"){
                    TextField(
                        "Distance",
                        value: $totalInput, format: .number
                    ).keyboardType(.decimalPad).focused($inputIsFocused)
                }
                
                Section("Input Result"){
                    Text("\(totalInput.formatted()) \(selectedInputUnit)")
                }
                
                Section("Output Result"){
                    Text("\(totalOutput.formatted()) \(selectedOutputUnit)")
                }
            }
            .navigationTitle("Length Conversion")
            .toolbar{
                if inputIsFocused{
                    Button("Done"){
                        inputIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
