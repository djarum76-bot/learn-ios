//
//  EditViewModel.swift
//  Study
//
//  Created by habil . on 31/12/23.
//

import Foundation

@MainActor class EditViewModel: ObservableObject{
    var id: Int
    var image: String
    @Published var description: String
    
    @Published private(set) var networkingState = NetworkingState.initial
    @Published private(set) var editError: EditError?
    @Published var hasError = false
    
    private let networkingManager: NetworkingManager!
    
    init(id: Int, image: String, description: String, networkingManager: NetworkingManager = NetworkingManagerImpl.shared) {
        self.id = id
        self.image = image
        _description = Published(initialValue: description)
        self.networkingManager = networkingManager
    }
    
    func editPost(onSuccess: () -> Void) async {
        networkingState = .loading
        
        do {
            let editModel = EditModel(id: id, description: description)
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(editModel)
            
            try await networkingManager.request(session: .shared, .updatePost(submissionData: data))
            
            networkingState = .success
            onSuccess()
            reset()
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.editError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.editError = .system(error: error)
            }
        }
    }
    
    private func reset() {
        networkingState = NetworkingState.initial
        editError = nil
        hasError = false
    }
}

extension EditViewModel {
    enum EditError: LocalizedError {
        case networking(error: LocalizedError)
        case system(error: Error)
    }
}

extension EditViewModel.EditError {
    var errorDescription: String? {
        switch self {
        case .networking(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

extension EditViewModel.EditError: Equatable {
    static func == (lhs: EditViewModel.EditError, rhs: EditViewModel.EditError) -> Bool {
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
