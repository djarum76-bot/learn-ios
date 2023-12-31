//
//  AddView.swift
//  Study
//
//  Created by habil . on 31/12/23.
//

import PhotosUI
import SwiftUI

struct AddView: View {
    @StateObject private var addVM = AddViewModel()
    @EnvironmentObject private var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Form {
                PhotosPicker(selection: $addVM.pickerImage){
                    if addVM.uiImage != nil {
                        Image(uiImage: addVM.uiImage!)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 8))
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .onChange(of: addVM.pickerImage){
                    Task{
                        await addVM.takeImage()
                    }
                }
                
                Section("Put your description here"){
                    TextEditor(text: $addVM.description)
                }
            }
            
            VStack{
                Spacer()
                
                HStack{
                    Spacer()
                    
                    Button{
                        Task{
                            await addVM.addPost{
                                Task{
                                    await homeVM.getAllPost()
                                    dismiss()
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.body.weight(.semibold))
                            .tint(.white)
                            .padding(15)
                            .background(addVM.isDisable ? .gray.opacity(0.25) : .blue)
                            .clipShape(.circle)
                            .shadow(radius: 4, x: 0, y: 4)
                            .padding([.trailing, .bottom])
                    }
                    .disabled(addVM.isDisable)
                }
            }
        }
        .alert("Oops...", isPresented: $addVM.showingAlert){} message: {
            Text(addVM.alertMessage)
        }
    }
}

#Preview {
    AddView()
        .environmentObject(HomeViewModel())
}
