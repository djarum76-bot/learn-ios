//
//  LoginView.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginVM = LoginViewModel()
    @EnvironmentObject private var authManager: AuthManager
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
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if authManager.getToken() != "" {
                    routeManager.path.append(Route.dashboard)
                }
            }
        }
        .navigationTitle("Login")
        .alert("Oops...", isPresented: $loginVM.hasError) {} message: {
            Text(loginVM.loginError?.errorDescription ?? "You encountering an error")
        }
        .navigationDestination(for: String.self) { path in
            switch path{
            case Route.dashboard:
                DashboardView()
                    .navigationBarBackButtonHidden(true)
                    .environmentObject(routeManager)
            case Route.register:
                RegisterView()
                    .environmentObject(routeManager)
            default: EmptyView()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
        .environmentObject(RouteManager())
}
