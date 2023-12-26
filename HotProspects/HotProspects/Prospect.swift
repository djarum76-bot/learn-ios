//
//  Prospect.swift
//  HotProspects
//
//  Created by habil . on 26/12/23.
//

import SwiftUI

class Prospect: Identifiable, Codable{
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    var createdAt = Date.now
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    let saveKey = "SavedData"
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
    
    init() {
//        if let data = UserDefaults.standard.data(forKey: saveKey) {
//            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data){
//                people = decoded
//                return
//            }
//        }
//        
//        people = []
        
        do {
            let data = try Data(contentsOf: savePath)
            people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            people = []
        }
    }
    
    private func save() {
//        if let encoded = try? JSONEncoder().encode(people) {
//            UserDefaults.standard.setValue(encoded, forKey: saveKey)
//        }
        
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
