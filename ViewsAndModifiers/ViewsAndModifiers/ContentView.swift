//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by habil . on 17/12/23.
//

import SwiftUI

struct Title: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View{
    func titleStyle() -> some View{
        modifier(Title())
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello")
                .titleStyle()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
