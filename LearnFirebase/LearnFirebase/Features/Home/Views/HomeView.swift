//
//  HomeView.swift
//  LearnFirebase
//
//  Created by habil . on 04/01/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack{
            NavigationLink{
                FirestoreView()
            } label: {
                Text("Firestore")
                    .font(.headline)
                    .padding()
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(.rect(cornerRadius: 16))
            }
            
            NavigationLink{
                StorageView()
            } label: {
                Text("Storage")
                    .font(.headline)
                    .padding()
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(.rect(cornerRadius: 16))
            }
        }
        .navigationTitle("Learn Firebase")
    }
}

#Preview {
    NavigationStack{
        HomeView()
    }
}
