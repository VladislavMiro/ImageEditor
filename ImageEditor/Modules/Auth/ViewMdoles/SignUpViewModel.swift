//
//  SignUpViewModel.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import Foundation
import FirebaseAuth

final class SignUpViewModel {
    
    //MARK: - Public properties
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isError: Bool = false
    @Published var isLoading: Bool = false
    @Published var isSignedUp: Bool = false
    @Published var isPasswordValid: Bool = true
    @Published var isEmailValid: Bool = true
    
}

//MARK: - Extension with SignUpViewModelProtocol implementation

extension SignUpViewModel: SignUpViewModelProtocol {
    
    func signUp() {
        isEmailValid = CredentialsValidator.emailIsValid(email: email)
        isPasswordValid = CredentialsValidator.passwordIsValid(password: password)
        
        guard isEmailValid && isPasswordValid else { return  }
        
        isLoading = true
        
        Task.detached(priority: .userInitiated) { [unowned self] in
            do {
                
                try await Auth.auth().createUser(withEmail: email, password: password)
                try await Auth.auth().currentUser?.sendEmailVerification()
                
                await MainActor.run {
                    isLoading = false
                    isSignedUp = true
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isError = true
                    isLoading = false
                }
            }
        }
        
    }
    
}
