//
//  DetailViewModel.swift
//  Pagination
//
//  Created by habil . on 28/12/23.
//

import Foundation

@MainActor class DetailViewModel: ObservableObject {
    @Published private(set) var user: User?
    @Published private(set) var state = ViewState.initial
    @Published var isShowingAlert = false
    @Published private(set) var alertTitle = "Oops..."
    @Published private(set) var alertMessage = ""
    
    func getUserDetail(id: Int) async {
        state = ViewState.loading
        
        do {
            let url = Endpoint.detail(id: id).url
            let (data, _) = try await URLSession.shared.data(from: url)
            let item = try JSONDecoder().decode(UserDetailResponse.self, from: data)
            user = item.data
            state = ViewState.success
        } catch {
            isShowingAlert = true
            alertMessage = error.localizedDescription
            state = ViewState.failed
        }
    }
}
