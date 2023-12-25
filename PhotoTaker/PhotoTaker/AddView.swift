//
//  AddView.swift
//  PhotoTaker
//
//  Created by habil . on 25/12/23.
//

import PhotosUI
import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: ViewModel
    
    init(onSave: @escaping (Photo) -> Void) {
        self.viewModel = ViewModel(onSave: onSave)
    }
    
    var body: some View {
        NavigationStack{
            Form{
                PhotosPicker(selection: $viewModel.pickerImage){
                    if viewModel.selectedImage != nil {
                        viewModel.selectedImage!
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .onChange(of: viewModel.pickerImage) {
                    Task {
                        await viewModel.takeImage()
                    }
                }
                
                Section("Name") {
                    TextField("", text: $viewModel.name)
                }
            }
            .navigationTitle("Add Person Data")
            .toolbar{
                Button("Save"){
                    viewModel.save()
                    
                    dismiss()
                }.disabled(viewModel.selectedData == nil || viewModel.name.isEmpty)
            }
        }
    }
}

#Preview {
    AddView(){ _ in }
}
