//
//  FirestoreView.swift
//  LearnFirebase
//
//  Created by habil . on 04/01/24.
//

import SwiftUI

struct FirestoreView: View {
    @StateObject private var firestoreVM = FirestoreViewModel()
    
    var body: some View {
        Form{
            ForEach(firestoreVM.users) { user in
                HStack{
                    VStack(alignment: .leading){
                        Text("\(user.name) (\(user.age))")
                            .font(.headline)
                        
                        Text(user.email)
                    }
                    
                    Button{
                        Task{
                            await firestoreVM.deleteDataFromFirestore(id: user.id){
                                await firestoreVM.getDataFromFirestore()
                            }
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .navigationTitle("Firestore")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            Button("Plus", systemImage: "plus"){
                firestoreVM.showingSheet.toggle()
            }
        }
        .sheet(isPresented: $firestoreVM.showingSheet){
            AddFirestoreView()
                .environmentObject(firestoreVM)
        }
        .task {
            await firestoreVM.getDataFromFirestore()
        }
        .refreshable {
            await firestoreVM.getDataFromFirestore()
        }
    }
}

#Preview {
    NavigationStack{
        FirestoreView()
    }
}
