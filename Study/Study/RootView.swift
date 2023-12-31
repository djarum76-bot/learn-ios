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
    
    var body: some View {
        NavigationStack(path: $routeManager.path){
            SplashView()
                .environmentObject(authManager)
                .environmentObject(routeManager)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthManager.shared)
        .environmentObject(RouteManager())
}
