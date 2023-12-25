//
//  AddView-ViewModel.swift
//  PhotoTaker
//
//  Created by habil . on 25/12/23.
//

import Foundation
import PhotosUI
import SwiftUI

extension AddView{
    @MainActor class ViewModel: ObservableObject{
        var onSave: (Photo) -> Void
        
        @Published var pickerImage: PhotosPickerItem?
        @Published var selectedData: Data?
        @Published var selectedImage: Image?
        @Published var name: String = ""
        
        let locationFetcher = LocationFetcher()
        
        init(onSave: @escaping (Photo) -> Void) {
            self.locationFetcher.start()
            self.onSave = onSave
        }
        
        func takeImage()async{
            do {
                guard let inputData = try await pickerImage?.loadTransferable(type: Data.self) else { return }
                guard let inputImage = UIImage(data: inputData) else { return }
                
                selectedData = inputData
                selectedImage = Image(uiImage: inputImage)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func save(){
            if let location = self.locationFetcher.lastKnownLocation{
                let photo = Photo(id: UUID(), name: name, image: selectedData!, latitude: location.latitude, longitude: location.longitude)
                onSave(photo)
            } else {
                print("Your location is unknown")
            }
        }
    }
}
