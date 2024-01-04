//
//  HomeView.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var profileVM = ProfileViewModel()
    @EnvironmentObject private var routeManager: RouteManager
    
    var body: some View {
        Form{
            switch profileVM.networkingState{
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
                Section("About me"){
                    Text(profileVM.user?.name ?? "")
                    Text(profileVM.user?.email ?? "")
                }
                
                Section{
                    Button("Logout", role: .destructive){
                        profileVM.showingAlert.toggle()
                    }
                }
            case .failed:
                Section{
                    HStack{
                        Spacer()
                        Text("\(profileVM.profileError?.errorDescription ?? "You encountering an error")\nPull down to refresh")
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
        .navigationTitle("Me")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Hiks😥", isPresented: $profileVM.showingAlert) {
            Button("Cancel", role: .cancel){}
            Button("Yes", role: .destructive){
                profileVM.logout {
                    routeManager.path = NavigationPath()
                }
            }
        } message: {
            Text("Are u sure u want to logout?")
        }
        .alert("Oops...", isPresented: $profileVM.hasError) {} message: {
            Text(profileVM.profileError?.errorDescription ?? "You encountering an error")
        }
        .task {
            await profileVM.getUser()
        }
        .refreshable {
            await profileVM.getUser()
        }
    }
}

#Preview {
    NavigationStack{
        ProfileView()
            .environmentObject(RouteManager())
    }
}
