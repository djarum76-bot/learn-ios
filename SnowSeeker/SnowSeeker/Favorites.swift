//
//  Favorites.swift
//  SnowSeeker
//
//  Created by habil . on 28/12/23.
//

import Foundation

class Favorites: ObservableObject{
    private var resorts: Set<String>
    private let saveKey = "Favorites"
    
    init(){
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
                resorts = decoded
                return
            }
        }
        resorts = []
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort){
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort){
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    private func save(){
        if let encoded = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.setValue(encoded, forKey: saveKey)
        }
    }
}
