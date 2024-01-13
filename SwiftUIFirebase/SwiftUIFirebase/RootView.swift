//
//  RootView.swift
//  SwiftUIFirebase
//
//  Created by habil . on 03/01/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var rootVM = RootViewModel()
    
    var body: some View {
        ZStack{
            NavigationStack{
                SettingsView()
                    .environmentObject(rootVM)
            }
        }
        .onAppear{
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            rootVM.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $rootVM.showSignInView){
            NavigationStack{
                AuthenticationView()
                    .environmentObject(rootVM)
            }
        }
    }
}


#Preview {
    RootView()
}
