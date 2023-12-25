//
//  EditView.swift
//  BucketList
//
//  Created by habil . on 25/12/23.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ViewModel
    
    init(location: Location, onSave: @escaping (Location) -> Void){
        self.viewModel = ViewModel(location: location, onSave: onSave)
    }
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby..."){
                    switch viewModel.loadingState {
                    case .loading:
                        HStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar{
                Button("Save") {
                    viewModel.save()
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
}

#Preview {
    EditView(location: Location.example) { _ in }
}
