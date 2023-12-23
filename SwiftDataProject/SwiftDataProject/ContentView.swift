//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by habil . on 23/12/23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var showingUpcomingOnly = false
    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate)
    ]
    
    var body: some View {
        NavigationStack{
            UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
                .navigationTitle("Users")
                .toolbar {
                    Button("Add Samples", systemImage: "plus") {
                        try? modelContext.delete(model: User.self)
                        
                        let first = User(name: "Uzumaki Naruto", city: "Konoha", joinDate: .now.addingTimeInterval(86400 * -10))
                        let second = User(name: "Uchiha Sasuke", city: "Konoha", joinDate: .now.addingTimeInterval(86400 * -5))
                        let third = User(name: "Midoriya Izuku", city: "Tokyo", joinDate: .now.addingTimeInterval(86400 * 5))
                        let fourth = User(name: "Asta", city: "Clover", joinDate: .now.addingTimeInterval(86400 * 10))
                        
                        modelContext.insert(first)
                        modelContext.insert(second)
                        modelContext.insert(third)
                        modelContext.insert(fourth)
                    }
                    
                    Button(showingUpcomingOnly ? "Show Everyone" : "Show Upcoming") {
                        showingUpcomingOnly.toggle()
                    }
                    
                    Menu("Sort", systemImage: "arrow.up.arrow.down"){
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by name")
                                .tag([
                                    SortDescriptor(\User.name),
                                    SortDescriptor(\User.joinDate)
                                ])
                            
                            Text("Sort by join date")
                                .tag([
                                    SortDescriptor(\User.joinDate),
                                    SortDescriptor(\User.name),
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
