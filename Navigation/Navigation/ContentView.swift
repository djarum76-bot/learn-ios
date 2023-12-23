//
//  ContentView.swift
//  Navigation
//
//  Created by habil . on 21/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var title = "Swift"
    
    var body: some View {
        NavigationStack{
            Text("Hi")
                .navigationTitle($title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
