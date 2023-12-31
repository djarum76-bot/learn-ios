//
//  LoginView.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginVM = LoginViewModel()
    @EnvironmentObject private var routeManager: RouteManager
    
    var body: some View {
        VStack{
            AppTextField(title: "Email", text: $loginVM.email, textFocus: $loginVM.emailFocus)
            AppTextField(title: "Password", text: $loginVM.password, textFocus: $loginVM.passwordFocus, isSecure: true)
            
            Spacer().frame(height: 30)
            
            AppButton(label: "Login", disable: loginVM.isDisable, loading: loginVM.isLoading) {
                Task {
                    await loginVM.login {
                        routeManager.path = NavigationPath()
                        routeManager.path.append(Route.dashboard)
                    }
                    
                }
            }
            .disabled(loginVM.isDisable || loginVM.isLoading)
            
            Spacer()
            
            HStack(spacing: 5){
                Text("Don't have an account?")
                Button{
                    routeManager.path.append("Register")
                } label: {
                    Text("Register now")
                }
            }
        }
        .padding()
        .onTapGesture {
            loginVM.passwordFocus = false
        }
        .navigationTitle("Login")
        .alert("Oops...", isPresented: $loginVM.hasError) {} message: {
            Text(loginVM.loginError?.errorDescription ?? "You encountering an error")
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(RouteManager())
}
