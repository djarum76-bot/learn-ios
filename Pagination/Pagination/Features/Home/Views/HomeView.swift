//
//  HomeView.swift
//  Pagination
//
//  Created by habil . on 28/12/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack{
            HomeContentView()
                .environmentObject(homeViewModel)
                .task {
                    await homeViewModel.getUsers()
                }
                .refreshable {
                    await homeViewModel.refreshUsers()
                }
                .navigationTitle("Pagination")
                .navigationDestination(for: Int.self) { id in
                    DetailView(id: id)
                }
                .alert(homeViewModel.alertTitle, isPresented: $homeViewModel.isShowingAlert) {
                    Button("Try Again") {
                        Task {
                            await homeViewModel.getUsers()
                        }
                    }
                } message: {
                    Text(homeViewModel.alertMessage)
                }
        }
    }
}

fileprivate struct HomeContentView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        List{
            ForEach(homeViewModel.users) { user in
                HomeItemView(user: user)
                    .task {
                        if homeViewModel.hasReachedEnd(of: user) {
                            await homeViewModel.getUsers()
                        }
                    }
            }
        }
    }
}

#Preview {
    HomeView()
}
