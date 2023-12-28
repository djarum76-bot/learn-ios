//
//  HomeViewModel.swift
//  Pagination
//
//  Created by habil . on 28/12/23.
//

import Foundation

@MainActor class HomeViewModel: ObservableObject {
    @Published private(set) var users = [User]()
    @Published private(set) var totalPages = 1
    @Published private(set) var page = 1
    @Published private(set) var state = ViewState.initial
    @Published var isShowingAlert = false
    @Published private(set) var alertTitle = "Oops..."
    @Published private(set) var alertMessage = ""
    
    var isLoading: Bool {
        state == .loading
    }
    
    func getUsers() async {
        guard page != totalPages + 1 else { return }
        
        state = ViewState.loading
        
        do {
            let url = Endpoint.people(page: page).url
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(UsersResponse.self, from: data)
            users.append(contentsOf: items.data)
            totalPages = items.totalPages
            state = ViewState.success
            page += 1
        } catch {
            isShowingAlert = true
            alertMessage = error.localizedDescription
            state = ViewState.failed
        }
    }
    
    func refreshUsers() async {
        page = 1
        
        guard page != totalPages + 1 else { return }
        
        state = ViewState.loading
        
        do {
            let url = Endpoint.people(page: page).url
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(UsersResponse.self, from: data)
            users = items.data
            totalPages = items.totalPages
            state = ViewState.success
            page += 1
        } catch {
            isShowingAlert = true
            alertMessage = error.localizedDescription
            state = ViewState.failed
        }
    }
    
    func hasReachedEnd(of user: User) -> Bool {
        users.last?.id == user.id
    }
}
