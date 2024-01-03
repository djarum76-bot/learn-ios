//
//  SettingsView.swift
//  SwiftUIFirebase
//
//  Created by habil . on 03/01/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settingsVM = SettingsViewModel()
    @EnvironmentObject private var rootVM: RootViewModel
    
    var body: some View {
        List{
            Button("Log out", role: .destructive){
                settingsVM.signOut {
                    rootVM.showSignInView = true
                }
            }
            
            Section("Email function"){
                Button("Reset password", role: .destructive){
                    settingsVM.resetPassword()
                }
                
                Button("Update password", role: .destructive){
                    settingsVM.updatePassword()
                }
                
                Button("Update email", role: .destructive){
                    settingsVM.updateEmail()
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack{
        SettingsView()
            .environmentObject(RootViewModel())
    }
}
