//
//  RootView.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var routeManager: RouteManager
    
    var body: some View {
        NavigationStack(path: $routeManager.path){
            LoginView()
                .environmentObject(routeManager)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(RouteManager())
}
