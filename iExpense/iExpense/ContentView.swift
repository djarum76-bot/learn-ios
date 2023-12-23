//
//  ContentView.swift
//  iExpense
//
//  Created by habil . on 19/12/23.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable{
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses{
    var items = [ExpenseItem](){
        didSet{
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ExpenseTab: View {
    var expenses: Expenses
    let type: String
    
    var body: some View {
        List{
            ForEach(expenses.items){ item in
                if item.type == type{
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            
                            Text(item.type)
                        }
                        
                        Spacer()
                        
                        Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                }
            }
            .onDelete(perform: removeItem)
        }
    }
    
    func removeItem(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var expenses = Expenses()
    
    var body: some View {
        NavigationStack(path: $path){
            TabView{
                ExpenseTab(expenses: expenses, type: "Personal")
                .tabItem {
                    Label("Personal", systemImage: "person")
                }
                
                ExpenseTab(expenses: expenses, type: "Business")
                .tabItem {
                    Label("Business", systemImage: "bitcoinsign")
                }
            }
            .navigationTitle("iExpense")
            .toolbar{
                NavigationLink {
                    AddView(expenses: expenses)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
