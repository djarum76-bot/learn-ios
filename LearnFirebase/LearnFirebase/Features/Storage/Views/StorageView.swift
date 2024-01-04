//
//  StorageView.swift
//  LearnFirebase
//
//  Created by habil . on 04/01/24.
//

import PhotosUI
import SwiftUI

struct StorageView: View {
    @StateObject private var storageVM = StorageViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form{
            PhotosPicker(selection: $storageVM.pickerImage){
                if storageVM.selectedImage != nil {
                    storageVM.selectedImage!
                        .resizable()
                        .scaledToFit()
                } else {
                    ContentUnavailableView(
                        "No picture",
                        systemImage: "photo.badge.plus",
                        description: Text("Tap to import a photo")
                    )
                }
            }
            .onChange(of: storageVM.pickerImage) {
                Task {
                    await storageVM.takeImage()
                }
            }
        }
        .navigationTitle("Storage")
        .toolbar{
            Button("Save"){
                storageVM.uploadToStorage {
                    dismiss()
                }
            }
            .disabled(storageVM.selectedData == nil)
        }
    }
}

#Preview {
    StorageView()
}
