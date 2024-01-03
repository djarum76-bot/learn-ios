//
//  AuthenticationView.swift
//  SwiftUIFirebase
//
//  Created by habil . on 03/01/24.
//

import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

struct AuthenticationView: View {
    @StateObject private var authenticationVM = AuthenticationViewModel()
    @EnvironmentObject private var rootVM: RootViewModel
    
    var body: some View {
        VStack{
            NavigationLink {
                SignInEmailView()
                    .environmentObject(rootVM)
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .clipShape(.rect(cornerRadius: 10))
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)){}
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack{
        AuthenticationView()
            .environmentObject(RootViewModel())
    }
}
