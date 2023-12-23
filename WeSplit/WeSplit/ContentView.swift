//
//  ContentView.swift
//  WeSplit
//
//  Created by habil . on 17/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var amountOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    var total: Double{
        let tipSelection = Double(tipPercentage)
        
        return checkAmount + (checkAmount * (tipSelection / 100))
    }
    
    var totalPerPerson: Double{
        let peopleCount = Double(amountOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        return (checkAmount + (checkAmount * (tipSelection / 100))) / peopleCount
    }
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField(
                        "Amount",
                        value: $checkAmount,
                        format: .currency(code: Locale.current.currency?.identifier ?? "USD")
                    )
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $amountOfPeople){
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                }
                
                Section("How much do you want to tip?"){
                    Picker("Tip percentage", selection: $tipPercentage){
                        ForEach(0..<101, id: \.self){
                            Text($0, format: .percent)
                        }
                    }.pickerStyle(.navigationLink)
                }
                
                Section("Amount per person"){
                    Text(
                        totalPerPerson,
                        format: .currency(code: Locale.current.currency?.identifier ?? "USD")
                    ).foregroundStyle(tipPercentage == 0 ? .red : .primary)
                }
                
                Section("Original amount"){
                    Text(
                        total,
                        format: .currency(code: Locale.current.currency?.identifier ?? "USD")
                    ).foregroundStyle(tipPercentage == 0 ? .red : .primary)
                }
            }
            .navigationTitle("WeSplit")
            .toolbar{
                if amountIsFocused{
                    Button("Done"){
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
