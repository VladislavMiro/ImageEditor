//
//  SignInViewModel.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

final class SignInViewModel {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isError: Bool = false
    @Published var isEmailValid: Bool = true
    @Published var isLoading: Bool = false
    @Published var isSignedIn: Bool = false
    
}

//MARK: - Extension with SignInViewModelProtocol implementation

extension SignInViewModel: SignInViewModelProtocol {
    
    func signIn() {
        isEmailValid = CredentialsValidator.emailIsValid(email: email)
        
        guard isEmailValid else { return }
        
        isLoading = true
        
        Task.detached(priority: .userInitiated) { [unowned self] in
            do {
                try await Auth.auth().signIn(withEmail: email, password: password)
                
                await MainActor.run {
                    isLoading = false
                    isSignedIn = true
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
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID
        else {
            errorMessage = "Firebase client ID is empty."
            isError = true
            
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScnene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScnene.windows.first,
              let vc = window.rootViewController
        else {
            fatalError("Root view controller not found")
        }
        
        isLoading = true
        
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { [unowned self] result, error in
            if let error = error {
                isLoading = false
                errorMessage = error.localizedDescription
                isError = true
                
                return
            }
            
            guard let user = result?.user, let token = user.idToken?.tokenString else {
                isLoading = false
                errorMessage = "Google token is empty."
                isError = true
                
                return
            }
            
            let credentials = GoogleAuthProvider.credential(withIDToken: token, accessToken: user.accessToken.tokenString)
            
            signIn(with: credentials)
        }
        
    }
    
}

//MARK: - Extension with private methods

private extension SignInViewModel {
    
    func signIn(with credentials: AuthCredential) {
        Task(priority: .userInitiated) { [unowned self] in
            do {
                try await Auth.auth().signIn(with: credentials)
                
                await MainActor.run {
                    isLoading = false
                    isSignedIn = true
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
