//
//  DetailView.swift
//  HabitTracking
//
//  Created by habil . on 21/12/23.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var amount = 0
    @State private var showingAlert = false
    
    var habits: Habits
    var habitItem: HabitItem
    
    init(habits: Habits, habitItem: HabitItem){
        self.habits = habits
        self.habitItem = habitItem
        self._amount = State(initialValue: habitItem.amount)
    }
    
    var body: some View {
        Form{
            Section("Description"){
                Text(habitItem.descriptionDisplay)
            }
            
            Section("Amount"){
                Stepper(value: $amount, in: 0...1000) {
                    Text("Completed : \(amount)")
                }
            }
        }
        .navigationTitle(habitItem.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            Button("Save", action: editHabit)
        }
    }
    
    func editHabit(){
        let habitIndex = habits.items.firstIndex(of: habitItem) ?? 0
        let habit = HabitItem(name: habitItem.name, description: habitItem.description, amount: amount)
        habits.items[habitIndex] = habit
        
        dismiss()
    }
}

#Preview {
    DetailView(habits: Habits(), habitItem: HabitItem(name: "Test", description: "Habilasd asd asd "))
}
