//
//  HomeItem.swift
//  Study
//
//  Created by habil . on 31/12/23.
//

import SwiftUI

struct HomeItem: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading){
            Text(post.user.name)
                .font(.headline)
            
            AsyncImage(url: URL(string: "\(Url.base)\(post.image)")) { image in
                image
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.gray.opacity(0.1))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            
            Text(post.description)
                .font(.body)
            
            Text(post.formattedDate)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    HomeItem(post: Post.example)
}
