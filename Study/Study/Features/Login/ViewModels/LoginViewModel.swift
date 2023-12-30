//
//  LoginViewModel.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import Foundation
import SwiftUI

@MainActor class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var emailFocus = false
    @Published var password = ""
    @Published var passwordFocus = false
    
    @Published private(set) var networkingState = NetworkingState.initial
    @Published private(set) var loginError: LoginError?
    @Published var hasError = false
    
    private let networkingManager: NetworkingManager!
    private let formValidator: FormValidator!
    private var loginResponse: Response<Token>?
    
    var isDisable: Bool {
        email.isEmpty || password.isEmpty
    }
    
    var isLoading: Bool {
        networkingState == .loading
    }
    
    init(networkingManager: NetworkingManager = NetworkingManagerImpl.shared, formValidator: FormValidator = FormValidatorImpl()) {
        self.networkingManager = networkingManager
        self.formValidator = formValidator
    }
    
    func login(onSuccess: () -> Void) async {
        networkingState = .loading
        
        do {
            try formValidator.validate(email: email, password: password)
            let loginModel = LoginModel(email: email, password: password)
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(loginModel)
            
            loginResponse = try await networkingManager.request(session: .shared, .login(submissionData: data), type: Response<Token>.self)
            AuthManager.shared.setToken(token: loginResponse?.data.token ?? "")
            
            networkingState = .success
            onSuccess()
            reset()
        } catch {
            hasError = true
            networkingState = .failed
            
            switch error {
                
            case is NetworkingManagerImpl.NetworkingError:
                self.loginError = .networking(error: error as! NetworkingManagerImpl.NetworkingError)
            case is FormValidatorImpl.FormValidatorImplError:
                self.loginError = .validation(error: error as! FormValidatorImpl.FormValidatorImplError)
            default:
                self.loginError = .system(error: error)
            }
        }
    }
    
    private func reset() {
        email = ""
        emailFocus = false
        password = ""
        passwordFocus = false
        
        networkingState = NetworkingState.initial
        loginError = nil
        hasError = false
        
        loginResponse = nil
    }
}

extension LoginViewModel {
    enum LoginError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension LoginViewModel.LoginError {
    
    var errorDescription: String? {
        switch self {
        case .networking(let err), .validation(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

extension LoginViewModel.LoginError: Equatable {
    
    static func == (lhs: LoginViewModel.LoginError, rhs: LoginViewModel.LoginError) -> Bool {
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
