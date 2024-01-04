//
//  DashboardView.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var routeManager: RouteManager
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .environmentObject(routeManager)
    }
}

#Preview {
    NavigationStack{
        DashboardView()
            .environmentObject(RouteManager())
    }
}
