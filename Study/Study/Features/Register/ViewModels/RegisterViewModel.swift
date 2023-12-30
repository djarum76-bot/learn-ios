//
//  RegisterViewModel.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import Foundation

@MainActor class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var nameFocus = false
    @Published var email = ""
    @Published var emailFocus = false
    @Published var password = ""
    @Published var passwordFocus = false
    
    var isDisable: Bool {
        name.isEmpty || email.isEmpty || password.isEmpty
    }
    
    var isLoading: Bool {
        networkingState == .loading
    }
    
    @Published private(set) var networkingState = NetworkingState.initial
    @Published private(set) var registerError: RegisterError?
    @Published var hasError = false
    
    private let networkingManager: NetworkingManager!
    private let formValidator: FormValidator!
    private var registerResponse: Response<Token>?
    
    init(networkingManager: NetworkingManager = NetworkingManagerImpl.shared, formValidator: FormValidator = FormValidatorImpl()) {
        self.networkingManager = networkingManager
        self.formValidator = formValidator
    }
    
    func register(onSuccess: () -> Void) async {
        networkingState = .loading
        
        do {
            try formValidator.validate(email: email, password: password)
            let registerModel = RegisterModel(name: name, email: email, password: password)
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(registerModel)
            
            registerResponse = try await networkingManager.request(session: .shared, .register(submissionData: data), type: Response<Token>.self)
            AuthManager.shared.setToken(token: registerResponse?.data.token ?? "")
            
            networkingState = .success
            onSuccess()
            reset()
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.registerError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            case is FormValidatorImpl.FormValidatorImplError:
                self.registerError = .validation(error: error as! FormValidatorImpl.FormValidatorImplError)
            default:
                self.registerError = .system(error: error)
            }
        }
    }
    
    private func reset() {
        name = ""
        nameFocus = false
        email = ""
        emailFocus = false
        password = ""
        passwordFocus = false
        
        networkingState = NetworkingState.initial
        registerError = nil
        hasError = false
        
        registerResponse = nil
    }
}

extension RegisterViewModel {
    enum RegisterError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension RegisterViewModel.RegisterError {
    var errorDescription: String? {
        switch self {
        case .networking(let err), .validation(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

extension RegisterViewModel.RegisterError: Equatable {
    static func == (lhs: RegisterViewModel.RegisterError, rhs: RegisterViewModel.RegisterError) -> Bool {
        switch (lhs, rhs) {
        case (.networking(let lhsType), .networking(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.validation(let lhsType), .validation(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.system(let lhsType), .system(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}
