//
//  AddView.swift
//  iExpense
//
//  Created by habil . on 20/12/23.
//

import SwiftUI

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0

    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type){
                    ForEach(types, id: \.self){
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar{
                Button("Save"){
                    let expense = Expense(name: name, type: type, amount: amount)
                    modelContext.insert(expense)
                    
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView()
}
