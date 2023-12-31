//
//  HomeView.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()
    @EnvironmentObject private var routeManager: RouteManager
    
    var body: some View {
        ZStack{
            Form{
                switch homeVM.networkingState{
                case.loading:
                    Section{
                        HStack{
                            Spacer()
                            ProgressView()
                                .frame(alignment: .center)
                            Spacer()
                        }
                    }
                case .success:
                    List{
                        ForEach(homeVM.posts){ post in
                            Section{
                                HomeItem(post: post)
                            }
                            .swipeActions{
                                if AuthManager.shared.id == post.userID {
                                    Button("Delete") {
                                        Task {
                                            await homeVM.deletePost(post: post)
                                        }
                                    }
                                    .tint(.red)
                                    
                                    Button("Edit") {
                                        homeVM.navigateToEdit(post: post)
                                    }
                                    .tint(.green)
                                }
                            }
                        }
                    }
                case .failed:
                    Section{
                        HStack{
                            Spacer()
                            Text("\(homeVM.homeError?.errorDescription ?? "You encountering an error")\nPull down to refresh")
                                .multilineTextAlignment(.center)
                                .frame(alignment: .center)
                            Spacer()
                        }
                    }
                case .initial:
                    Section{
                        HStack{
                            Spacer()
                            Text("Pull down to refresh")
                                .multilineTextAlignment(.center)
                                .frame(alignment: .center)
                            Spacer()
                        }
                    }
                }
            }
            
            VStack{
                Spacer()
                
                HStack{
                    Spacer()
                    
                    Button{
                        homeVM.showingAddSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.body.weight(.semibold))
                            .tint(.white)
                            .padding(15)
                            .background(.blue)
                            .clipShape(.circle)
                            .shadow(radius: 4, x: 0, y: 4)
                            .padding([.trailing, .bottom])
                    }
                }
            }
        }
        .navigationTitle("Home")
        .alert("Oops...", isPresented: $homeVM.hasError) {} message: {
            Text(homeVM.homeError?.errorDescription ?? "You encountering an error")
        }
        .task {
            await homeVM.getAllPost()
        }
        .refreshable {
            await homeVM.getAllPost()
        }
        .sheet(isPresented: $homeVM.showingAddSheet) {
            AddView()
                .environmentObject(homeVM)
        }
        .sheet(isPresented: $homeVM.showingEditSheet) {
            EditView(id: homeVM.post?.id ?? 0, image: homeVM.post?.image ?? "", description: homeVM.post?.description ?? "")
                .environmentObject(homeVM)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(RouteManager())
}
