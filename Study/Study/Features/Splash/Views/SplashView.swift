//
//  SplashView.swift
//  Study
//
//  Created by habil . on 31/12/23.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var routeManager: RouteManager
    
    var body: some View {
        Image(systemName: "book")
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue.gradient)
            .foregroundStyle(.white)
            .onAppear{
                print("1")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    print("2")
                    if authManager.getToken() == "" {
                        print("3")
                        routeManager.path.append(Route.login)
                    } else {
                        print("4")
                        routeManager.path.append(Route.dashboard)
                    }
                }
                print("5")
            }
            .navigationDestination(for: String.self) { path in
                switch path{
                case Route.login:
                    LoginView()
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(routeManager)
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
    SplashView()
        .environmentObject(AuthManager.shared)
        .environmentObject(RouteManager())
}
