//
//  DetailView.swift
//  FriendFace
//
//  Created by habil . on 23/12/23.
//

import SwiftUI

struct DetailView: View {
    let user: User
    
    var body: some View {
        Form{
            Section("About"){
                Text(user.about)
            }
            
            Section{
                Text("Age : \(user.age)")
                Text("Email : \(user.email)")
                Text("Company : \(user.company)")
                Text("Address : \(user.address)")
                Text("Registered : \(user.formattedDate)")
            }
            
            Section("Tags"){
                ForEach(user.tags, id: \.self) {
                    Text("- \($0)")
                }
            }
            
            Section("Friends"){
                ForEach(user.friends, id: \.id) {
                    Text("- \($0.name)")
                }
            }
        }
        .navigationTitle("\(user.name) - \(user.isActive ? "Active" : "Not Active")")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    let user = User(id: "11", isActive: false, name: "Sasuke", age: 29, company: "Anbu", email: "sasuke@gmail.com", address: "Konoha", about: "Is the best ninja all time", registered: "2015-11-10T01:47:18-00:00", tags: ["Ninja"], friends: [Friend(id: "2e2e", name: "Naruto")])
//    
//    let user1 = User(from: <#T##Decoder#>)
//    
//    return DetailView(user: user)
//}
