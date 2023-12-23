//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by habil . on 23/12/23.
//

import SwiftData
import SwiftUI

@main
struct FriendFaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self, isAutosaveEnabled: false)
    }
}
