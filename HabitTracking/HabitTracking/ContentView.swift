//
//  ContentView.swift
//  HabitTracking
//
//  Created by habil . on 21/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAddExpense = false
    @State private var habits = Habits()
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(habits.items) { item in
                    NavigationLink(value: item) {
                        HStack{
                            VStack(alignment: .leading){
                                Text(item.name)
                                    .font(.headline)
                            }
                        }
                    }
                    .navigationDestination(for: HabitItem.self) { habit in
                        DetailView(habits: habits, habitItem: habit)
                    }
                }
                .onDelete(perform: removeItem)
            }
            .navigationTitle("Habit")
            .toolbar{
                Button{
                    showingAddExpense.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense){
                AddView(habits: habits)
            }
        }
    }
    
    func removeItem(offsets: IndexSet){
        habits.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
