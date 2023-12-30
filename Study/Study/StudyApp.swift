//
//  StudyApp.swift
//  Study
//
//  Created by habil . on 29/12/23.
//

import SwiftUI

@main
struct StudyApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var routeManager = RouteManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(routeManager)
        }
    }
}
