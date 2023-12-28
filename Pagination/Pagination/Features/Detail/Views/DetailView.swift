//
//  DetailView.swift
//  Pagination
//
//  Created by habil . on 28/12/23.
//

import SwiftUI

struct DetailView: View {
    let id: Int
    @StateObject private var detailViewModel = DetailViewModel()
    
    var body: some View {
        DetailContentView()
            .environmentObject(detailViewModel)
            .task {
                await detailViewModel.getUserDetail(id: id)
            }
            .refreshable {
                await detailViewModel.getUserDetail(id: id)
            }
            .navigationTitle("\(detailViewModel.user?.firstName ?? "") \(detailViewModel.user?.lastName ?? "")")
            .navigationBarTitleDisplayMode(.inline)
    }
}

fileprivate struct DetailContentView: View {
    @EnvironmentObject private var detailViewModel: DetailViewModel
    
    var body: some View {
        switch detailViewModel.state{
        case .loading:
            ProgressView()
        case .success:
            ScrollView{
                AsyncImage(url: URL(string: detailViewModel.user!.avatar), scale: 3) { image in
                    image
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 5)
                        )
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 250, height: 250)
                
                Text(detailViewModel.user!.email)
                    .font(.headline)
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(.capsule)
                    .padding()
            }
        default:
            Spacer()
        }
    }
}

#Preview {
    DetailView(id: 1)
}
