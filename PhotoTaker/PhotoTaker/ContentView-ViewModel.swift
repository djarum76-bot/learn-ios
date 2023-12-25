//
//  ContentView-ViewModel.swift
//  PhotoTaker
//
//  Created by habil . on 25/12/23.
//

import Foundation
import SwiftUI

extension ContentView{
    @MainActor class ViewModel: ObservableObject{
        @Published var photos = [Photo]()
        @Published var showingSheet = false
        let savePath = FileManager.picturesDirectory
        
        init(){
            do{
                let data = try Data(contentsOf: savePath)
                photos = try JSONDecoder().decode([Photo].self, from: data).sorted()
            } catch {
                photos = []
            }
        }
        
        func onSave(photo: Photo){
            photos.append(photo)
            
            do {
                let data = try JSONEncoder().encode(photos)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
