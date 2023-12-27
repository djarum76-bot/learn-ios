//
//  ViewModel.swift
//  Flashzilla
//
//  Created by habil . on 27/12/23.
//

import Foundation

@MainActor class ViewModel: ObservableObject {
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
    @Published var cards = [Card]()
    
    func loadData(){
        do {
            let data = try Data(contentsOf: savePath)
            cards = try JSONDecoder().decode([Card].self, from: data)
        } catch {
            print("Error Load Data : \(error.localizedDescription)")
        }
    }
    
    func saveData() {
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Error Save Data : \(error.localizedDescription)")
        }
    }
}
