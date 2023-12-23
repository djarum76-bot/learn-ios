//
//  ContentView.swift
//  FriendFace
//
//  Created by habil . on 23/12/23.
//

import SwiftData
import SwiftUI

#Preview {
    ContentView()
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]
    
    var body: some View {
        NavigationStack{
            List(users, id: \.id){ user in
                NavigationLink(value: user) {
                    HStack{
                        Text("\(user.name) (\(user.age)) - \(user.isActive ? "Active" : "Not Active")")
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Friend Face")
            .task {
                await getUser()
            }
            .navigationDestination(for: User.self) { user in
                DetailView(user: user)
            }
        }
    }
    
    func getUser() async {
        if users.isEmpty {
            guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
                print("Invalid URL")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                if let decodedResponse = try? JSONDecoder().decode([User].self, from: data) {
                    try modelContext.transaction {
                        for response in decodedResponse {
                            modelContext.insert(response)
                        }
                        
                        do {
                            try modelContext.save()
                        } catch {
                            print("Error here")
                        }
                    }
                }
            } catch {
                print("Error getting data from internet")
            }
        }
    }
}
