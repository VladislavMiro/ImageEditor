//
//  ResetPasswordViewModel.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import Foundation
import FirebaseAuth

final class ResetPasswordViewModel {
    
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var isValidEmail: Bool = true
    @Published var errorMessage: String = ""
    @Published var isError: Bool = false
    @Published var isPassworReset: Bool = false
    
}

//MARK: - Extension with ResetPasswordViewModelProtocol

extension ResetPasswordViewModel: ResetPasswordViewModelProtocol {
    
    func resetPassword() {
        isValidEmail = CredentialsValidator.emailIsValid(email: email)
        
        guard isValidEmail else { return }
        
        isLoading = true
        
        Task.detached(priority: .userInitiated) { [unowned self] in
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                
                await MainActor.run {
                    isLoading = false
                    isPassworReset = true
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = error.localizedDescription
                    isError = true
                }
            }
        }
    }
    
}
