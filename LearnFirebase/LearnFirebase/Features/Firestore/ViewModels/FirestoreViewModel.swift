//
//  FirestoreViewModel.swift
//  LearnFirebase
//
//  Created by habil . on 04/01/24.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

@MainActor
final class FirestoreViewModel: ObservableObject{
    @Published var showingSheet = false
    @Published var users: [User] = []
    
    func getDataFromFirestore() async {
        let db = Firestore.firestore()
        var tempUsers: [User] = []
        
        do {
            let snapshot = try await db.collection(Constants.users).getDocuments()
            for document in snapshot.documents {
                let id = document.documentID
                
                if let name = document.data()[Constants.name] as? String,
                   let email = document.data()[Constants.email] as? String,
                   let age = document.data()[Constants.age] as? Int {
                    let user = User(id: id, name: name, email: email, age: age)
                    tempUsers.append(user)
                }
            }
            
            users = tempUsers
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
    func deleteDataFromFirestore(id: String, onSuccess: @escaping () async -> Void) async {
        let db = Firestore.firestore()
        
        do {
            try await db.collection(Constants.users).document(id).delete()
            await onSuccess()
        } catch {
            print("Error deleting documents: \(error)")
        }
    }
}
