//
//  AddViewModel.swift
//  Study
//
//  Created by habil . on 31/12/23.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor class AddViewModel: ObservableObject{
    @Published var pickerImage: PhotosPickerItem?
    @Published var uiImage: UIImage?
    @Published var description: String = ""
    
    @Published private(set) var networkingState = NetworkingState.initial
    @Published private(set) var addError: AddError?
    @Published var hasError = false
    
    @Published var showingAlert = false
    @Published private(set) var alertMessage = ""
    
    private let networkingManager: NetworkingManager!
    
    init(networkingManager: NetworkingManager = NetworkingManagerImpl.shared) {
        self.networkingManager = networkingManager
    }
    
    var isDisable: Bool {
        uiImage == nil
    }
    
    func takeImage()async{
        do {
            guard let inputData = try await pickerImage?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: inputData) else { return }
            
            uiImage = inputImage
        } catch {
            showingAlert = true
            alertMessage = error.localizedDescription
        }
    }
    
    func addPost(onSuccess: () -> Void) async {
        networkingState = .loading
        
        do {
            try await networkingManager.addPost(session: .shared, .addPost(submissionData: nil), uiImage: uiImage!, description: description)
            
            networkingState = .success
            onSuccess()
            reset()
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.addError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            default:
                self.addError = .system(error: error)
            }
        }
    }
    
    private func reset() {
        networkingState = NetworkingState.initial
        addError = nil
        hasError = false
        showingAlert = false
        alertMessage = ""
        uiImage = nil
        description = ""
        pickerImage = nil
    }
}

extension AddViewModel {
    enum AddError: LocalizedError {
        case networking(error: LocalizedError)
        case system(error: Error)
    }
}

extension AddViewModel.AddError {
    var errorDescription: String? {
        switch self {
        case .networking(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

extension AddViewModel.AddError: Equatable {
    static func == (lhs: AddViewModel.AddError, rhs: AddViewModel.AddError) -> Bool {
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
