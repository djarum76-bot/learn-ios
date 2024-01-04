//
//  StorageViewModel.swift
//  LearnFirebase
//
//  Created by habil . on 04/01/24.
//

import Foundation
import PhotosUI
import SwiftUI
import FirebaseStorage

@MainActor
final class StorageViewModel: ObservableObject{
    @Published var pickerImage: PhotosPickerItem?
    @Published var selectedData: Data?
    @Published var selectedImage: Image?
    
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
    
    func uploadToStorage(onSuccess: @escaping () -> Void){
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        let riversRef = storageRef.child("images/\(Int(Date().timeIntervalSince1970)).jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(selectedData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                
                print(downloadURL.absoluteString)
                onSuccess()
            }
        }
    }
}
