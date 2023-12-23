//
//  UsersView.swift
//  SwiftDataProject
//
//  Created by habil . on 23/12/23.
//

import SwiftData
import SwiftUI

struct UsersView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]
    
    var body: some View {
        List(users) { user in
            HStack{
                Text(user.name)
                
                Spacer()
                
                Text(String(user.unwrappedJobs.count))
                    .fontWeight(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
        }
        .onAppear(perform: addSamples)
    }
    
    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        _users = Query(
            filter: #Predicate<User> { user in
                user.joinDate >= minimumJoinDate
            },
            sort: sortOrder
        )
    }
    
    func addSamples(){
        let user1 = User(name: "Sakura Haruno", city: "Konoha", joinDate: .now)
        let job1 = Job(name: "Ninja", priority: 1)
        let job2 = Job(name: "iOS Developer", priority: 2)
        
        modelContext.insert(user1)
        
        user1.jobs?.append(job1)
        user1.jobs?.append(job2)
    }
}

#Preview {
    UsersView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
}
