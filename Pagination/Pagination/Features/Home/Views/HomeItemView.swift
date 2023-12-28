//
//  HomeItemView.swift
//  Pagination
//
//  Created by habil . on 28/12/23.
//

import SwiftUI

struct HomeItemView: View {
    let user: User
    
    var body: some View {
        NavigationLink(value: user.id) {
            AsyncImage(url: URL(string: user.avatar), scale: 3) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 1)
                    )
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text("\(user.firstName) \(user.lastName)")
                    .font(.headline)
                
                Text(user.email)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    HomeItemView(user: User.example)
}
