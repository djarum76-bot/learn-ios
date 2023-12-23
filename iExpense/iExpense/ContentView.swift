//
//  ContentView.swift
//  iExpense
//
//  Created by habil . on 19/12/23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var showingPersonalOnly = true
    @State private var sortOrder = [
        SortDescriptor(\Expense.name),
        SortDescriptor(\Expense.amount)
    ]
    
    var body: some View {
        NavigationStack(path: $path){
            ExpensesView(sortOrder: sortOrder, type: showingPersonalOnly ? "Personal" : "Business")
                .navigationTitle("iExpense")
                .toolbar{
                    NavigationLink {
                        AddView()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    Button(showingPersonalOnly ? "Show Business" : "Show Personal"){
                        showingPersonalOnly.toggle()
                    }
                    
                    Menu("Sort", systemImage: "arrow.up.arrow.down"){
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by name")
                                .tag([
                                    SortDescriptor(\Expense.name),
                                    SortDescriptor(\Expense.amount)
                                ])
                            
                            Text("Sort by amount")
                                .tag([
                                    SortDescriptor(\Expense.amount),
                                    SortDescriptor(\Expense.name),
                                ])
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
