//
//  SettingsViewModel.swift
//  SwiftUIFirebase
//
//  Created by habil . on 03/01/24.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject{
    func signOut(onSuccess: @escaping () -> Void){
        Task {
            do {
                try AuthenticationManager.shared.signOut()
                onSuccess()
            } catch {
                print("Error : \(error)")
            }
        }
    }
    
    func resetPassword(){
        Task {
            do {
                let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
                
                guard let email = authUser.email else {
                    print("email not found")
                    return
                }
                
                try await AuthenticationManager.shared.resetPassword(email: email)
            } catch {
                print("Error : \(error)")
            }
        }
    }
    
    func updatePassword(){
        Task {
            do {
                let password = "12345678"
                try await AuthenticationManager.shared.updatePassword(password: password)
            } catch {
                print("Error : \(error)")
            }
        }
    }
    
    func updateEmail(){
        Task {
            do {
                let email = "test@gmail.com"
                try await AuthenticationManager.shared.updateEmail(email: email)
            } catch {
                print("Error : \(error)")
            }
        }
    }
}
