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
    }
}

#Preview {
    SplashView()
        .environmentObject(AuthManager.shared)
        .environmentObject(RouteManager())
}
