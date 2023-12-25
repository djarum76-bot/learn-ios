//
//  ContentView.swift
//  PhotoTaker
//
//  Created by habil . on 25/12/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack{
            List(viewModel.photos) { photo in
                NavigationLink(value: photo) {
                    VStack(alignment: .leading){
                        photo.image.convertDatatoImage()
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                        Text(photo.name)
                    }
                }
            }
            .navigationTitle("Photo Taker")
            .navigationDestination(for: Photo.self, destination: { photo in
                DetailView(photo: photo)
            })
            .toolbar {
                Button("Add", systemImage: "plus") {
                    viewModel.showingSheet.toggle()
                }
            }
            .sheet(isPresented: $viewModel.showingSheet){
                AddView(){ photo in
                    viewModel.onSave(photo: photo)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
