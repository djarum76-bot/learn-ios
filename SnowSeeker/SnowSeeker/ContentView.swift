//
//  ContentView.swift
//  SnowSeeker
//
//  Created by habil . on 28/12/23.
//

import SwiftUI

//UIDevice.current.userInterfaceIdiom == .phone
//to know what device is use right now

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        if sizeClass == .compact {
            NavigationStack{
                ResortsView()
            }
        } else {
            NavigationSplitView {
                ResortsView()
            } detail: {
                WelcomeView()
            }
            .navigationSplitViewStyle(.balanced)
        }
    }
}

#Preview {
    ContentView()
}
