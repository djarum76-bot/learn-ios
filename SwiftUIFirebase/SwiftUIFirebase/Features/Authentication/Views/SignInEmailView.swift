//
//  SignInEmailView.swift
//  SwiftUIFirebase
//
//  Created by habil . on 03/01/24.
//

import SwiftUI

struct SignInEmailView: View {
    @StateObject private var signInEmailVM = SignInEmailViewModel()
    @EnvironmentObject private var rootVM: RootViewModel
    
    var body: some View {
        VStack{
            TextField("Email...", text: $signInEmailVM.email)
                .padding()
                .background(.gray.opacity(0.4))
                .clipShape(.rect(cornerRadius: 10))
            
            SecureField("Password...", text: $signInEmailVM.password)
                .padding()
                .background(.gray.opacity(0.4))
                .clipShape(.rect(cornerRadius: 10))
            
            Button{
                Task{
                    do {
                        try await signInEmailVM.signUp()
                        rootVM.showSignInView = false
                        return
                    } catch {
                        print("Error : \(error)")
                    }
                    
                    do {
                        try await signInEmailVM.signIn()
                        rootVM.showSignInView = false
                        return
                    } catch {
                        print("Error : \(error)")
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .clipShape(.rect(cornerRadius: 10))
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

#Preview {
    NavigationStack{
        SignInEmailView()
            .environmentObject(RootViewModel())
    }
}
