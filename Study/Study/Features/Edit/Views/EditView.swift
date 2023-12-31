//
//  EditView.swift
//  Study
//
//  Created by habil . on 31/12/23.
//

import SwiftUI

struct EditView: View {
    @ObservedObject private var editVM: EditViewModel
    @EnvironmentObject private var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    init(id: Int, image: String, description: String) {
        self.editVM = EditViewModel(id: id, image: image, description: description)
    }
    
    var body: some View {
        ZStack{
            Form {
                AsyncImage(url: URL(string: "\(Url.base)\(editVM.image)")) { image in
                    image
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color.gray.opacity(0.1))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                
                Section("Edit your description here"){
                    TextEditor(text: $editVM.description)
                }
            }
            
            VStack{
                Spacer()
                
                HStack{
                    Spacer()
                    
                    Button{
                        Task{
                            await editVM.editPost{
                                Task{
                                    await homeVM.getAllPost()
                                    dismiss()
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "pencil")
                            .font(.body.weight(.semibold))
                            .tint(.white)
                            .padding(15)
                            .background(.blue)
                            .clipShape(.circle)
                            .shadow(radius: 4, x: 0, y: 4)
                            .padding([.trailing, .bottom])
                    }
                }
            }
        }
        .alert("Oops...", isPresented: $editVM.hasError) {} message: {
            Text(editVM.editError?.errorDescription ?? "You encountering an error")
        }
    }
}

#Preview {
    EditView(id: 0, image: "images/1704033423.jpeg", description: "AAA")
        .environmentObject(HomeViewModel())
}
