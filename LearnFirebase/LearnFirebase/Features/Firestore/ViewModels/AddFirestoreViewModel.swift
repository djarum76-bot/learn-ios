//
//  AddFirestoreViewModel.swift
//  LearnFirebase
//
//  Created by habil . on 04/01/24.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

@MainActor
final class AddFirestoreViewModel: ObservableObject{
    @Published var name = ""
    @Published var email = ""
    @Published var age = 10
    
    func addDatoToFirestore(onSuccess: @escaping () async -> Void) async {
        let db = Firestore.firestore()
        
        do {
            try await db.collection(Constants.users).addDocument(data: [
                Constants.name: name,
                Constants.email: email,
                Constants.age: age
            ])
            await onSuccess()
        } catch {
            print("Error adding document: \(error)")
        }
    }
}
