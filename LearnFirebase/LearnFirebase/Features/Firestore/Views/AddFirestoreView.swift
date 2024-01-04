//
//  AddFirestoreView.swift
//  LearnFirebase
//
//  Created by habil . on 04/01/24.
//

import SwiftUI

struct AddFirestoreView: View {
    @StateObject private var addFirestoreVM = AddFirestoreViewModel()
    @EnvironmentObject private var firestoreVM: FirestoreViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form{
            Section("User Data"){
                TextField("Name", text: $addFirestoreVM.name)
                TextField("Email", text: $addFirestoreVM.email)
                Stepper("\(addFirestoreVM.age) years old", value: $addFirestoreVM.age, in: 2...100)
            }
            
            Button("Add Data to Firestore"){
                Task{
                    await addFirestoreVM.addDatoToFirestore{
                        await firestoreVM.getDataFromFirestore()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        AddFirestoreView()
            .environmentObject(FirestoreViewModel())
    }
}
