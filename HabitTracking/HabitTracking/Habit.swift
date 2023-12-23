//
//  Habit.swift
//  HabitTracking
//
//  Created by habil . on 21/12/23.
//

import Foundation

struct HabitItem: Identifiable, Codable, Hashable, Equatable{
    var id = UUID()
    var name: String
    let description: String
    var amount: Int = 0
    
    var descriptionDisplay: String{
        description.isEmpty ? "N/A" : description
    }
}

@Observable
class Habits{
    var items = [HabitItem](){
        didSet{
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            if let decodedItems = try? JSONDecoder().decode([HabitItem].self, from: savedItems){
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}
