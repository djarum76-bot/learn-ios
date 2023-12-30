//
//  RegisterView.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var registerVM = RegisterViewModel()
    @EnvironmentObject private var routeManager: RouteManager
    
    var body: some View {
        VStack{
            AppTextField(title: "Name", text: $registerVM.name, textFocus: $registerVM.nameFocus)
            AppTextField(title: "Email", text: $registerVM.email, textFocus: $registerVM.emailFocus)
            AppTextField(title: "Password", text: $registerVM.password, textFocus: $registerVM.passwordFocus, isSecure: true)
            
            Spacer().frame(height: 30)
            
            AppButton(label: "Register", disable: registerVM.isDisable, loading: registerVM.isLoading) {
                Task{
                    await registerVM.register{
                        routeManager.path.append(Route.dashboard)
                    }
                }
            }
            .disabled(registerVM.isDisable || registerVM.isLoading)
            
            Spacer()
            
            HStack(spacing: 5){
                Text("Already have an account?")
                Button{
                    routeManager.path.removeLast()
                } label: {
                    Text("Login now")
                }
            }
        }
        .padding()
        .onTapGesture {
            registerVM.passwordFocus = false
        }
        .navigationDestination(for: String.self) { path in
            switch path{
            case Route.dashboard:
                DashboardView()
                    .navigationBarBackButtonHidden(true)
                    .environmentObject(routeManager)
            default: EmptyView()
            }
        }
        .navigationTitle("Register")
        .alert("Oops...", isPresented: $registerVM.hasError) {} message: {
            Text(registerVM.registerError?.errorDescription ?? "You encountering an error")
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(RouteManager())
}
