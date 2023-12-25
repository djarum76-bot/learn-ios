//
//  ContentView.swift
//  AccessibiltyApp
//
//  Created by habil . on 25/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var value = 10
    
    var body: some View {
        VStack {
            Text("Value : \(value)")
            
            HStack{
                Button("Decrement"){
                    value -= 1
                }
                
                Button("Increment"){
                    value += 1
                }
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Value")
        .accessibilityValue(String(value))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                value += 1
            case .decrement:
                value -= 1
            default:
                print("Not handled.")
            }
        }
    }
}

#Preview {
    ContentView()
}
