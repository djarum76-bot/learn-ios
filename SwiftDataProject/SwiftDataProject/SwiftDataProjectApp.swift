//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by habil . on 23/12/23.
//

import SwiftData
import SwiftUI

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
