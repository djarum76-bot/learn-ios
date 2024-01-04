//
//  RootView.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var routeManager: RouteManager
    @State private var showLoginView = false
    
    var body: some View {
//        NavigationStack(path: $routeManager.path){
//            SplashView()
//                .environmentObject(authManager)
//                .environmentObject(routeManager)
//        }
        
        ZStack{
            NavigationStack{
                SplashView()
                    .environmentObject(authManager)
                    .environmentObject(routeManager)
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showLoginView = true
            }
        }
        .fullScreenCover(isPresented: $showLoginView){
            NavigationStack(path: $routeManager.path){
                LoginView()
                    .environmentObject(authManager)
                    .environmentObject(routeManager)
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthManager.shared)
        .environmentObject(RouteManager())
}
