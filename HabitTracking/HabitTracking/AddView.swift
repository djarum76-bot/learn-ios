//
//  AddView.swift
//  HabitTracking
//
//  Created by habil . on 21/12/23.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var showingAlert = false
    
    var habits: Habits
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $name)
                
                TextField("Description", text: $description, axis: .vertical)
            }
            .navigationTitle("Add new habit")
            .toolbar{
                Button("Save", action: addHabit)
            }
            .alert("Error", isPresented: $showingAlert){} message: {
                Text("Your name empty")
            }
        }
    }
    
    func addHabit(){
        if name.isEmpty {
            showingAlert = true
            return
        }
        
        let habit = HabitItem(name: name, description: description)
        habits.items.append(habit)
        
        dismiss()
    }
}

#Preview {
    
    AddView(habits: Habits())
}
