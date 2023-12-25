//
//  ContentView.swift
//  BucketList
//
//  Created by habil . on 25/12/23.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                Map(position: $viewModel.position) {
                    ForEach(viewModel.locations) { location in
                        Annotation("", coordinate: location.coordinate){
                            VStack{
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(Circle())
                                
                                Text(location.name)
                                    .fixedSize()
                            }
                            .onTapGesture {
                                viewModel.selectedPlace = location
                            }
                        }
                        .annotationTitles(.hidden)
                    }
                }
                .onMapCameraChange { context in
                    viewModel.onMapCameraChange(context: context)
                }
                .ignoresSafeArea()
                
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        Button{
                            viewModel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .padding()
                        .background(.black.opacity(0.75))
                        .foregroundStyle(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place) { newLocation in
                    viewModel.update(location: newLocation)
                }
            }
            .alert("Error", isPresented: $viewModel.showingAlert){} message: {
                Text(viewModel.alertMessage)
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    ContentView()
}
