//
//  HomeViewModel.swift
//  Study
//
//  Created by habil . on 31/12/23.
//

import Foundation

@MainActor class HomeViewModel: ObservableObject {
    @Published private(set) var networkingState = NetworkingState.initial
    @Published private(set) var homeError: HomeError?
    @Published var hasError = false
    @Published var showingAlert = false
    @Published var posts: [Post] = []
    @Published var showingSheet = false
    
    private let networkingManager: NetworkingManager!
    private var postsResponse: Response<[Post]>?
    
    init(networkingManager: NetworkingManager = NetworkingManagerImpl.shared) {
        self.networkingManager = networkingManager
    }
    
    func getAllPost() async {
        networkingState = .loading
        
        do {
            postsResponse = try await networkingManager.request(session: .shared, .getAllPost, type: Response<[Post]>.self)
            posts = postsResponse?.data ?? []
            
            networkingState = .success
        } catch {
            print(error)
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.homeError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.homeError = .system(error: error)
            }
        }
    }
    
    func deletePost(post: Post)async{
        networkingState = .loading
        
        do {
            try await networkingManager.request(session: .shared, .deletePost(id: post.id))
            
            networkingState = .success
            
            await getAllPost()
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.homeError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.homeError = .system(error: error)
            }
        }
    }
}

extension HomeViewModel {
    enum HomeError: LocalizedError {
        case networking(error: LocalizedError)
        case system(error: Error)
    }
}

extension HomeViewModel.HomeError {
    var errorDescription: String? {
        switch self {
        case .networking(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

extension HomeViewModel.HomeError: Equatable {
    static func == (lhs: HomeViewModel.HomeError, rhs: HomeViewModel.HomeError) -> Bool {
        switch (lhs, rhs) {
        case (.networking(let lhsType), .networking(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.system(let lhsType), .system(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}
