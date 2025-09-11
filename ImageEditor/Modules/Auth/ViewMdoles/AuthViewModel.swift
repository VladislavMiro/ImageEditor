//
//  AuthViewModel.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

final class AuthViewModel {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isError: Bool = false
    @Published var isValidEmail: Bool = true
    @Published var isValidPassword: Bool = true
    @Published var isLoading: Bool = false
    
}

//MARK: - Extension with AuthViewModelProtocol implementation

extension AuthViewModel: AuthViewModelProtocol {
    
    func signIn(completion: @escaping () -> Void) {
        isValidEmail = checkEmail(email)
        
        guard isValidEmail else { return }
        
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] result, error in
            isLoading = false
            
            if let error = error {
                errorMessage = error.localizedDescription
                isError = true
                
                return
            }
            
            completion()
        }
    }
    
    func signInWithGoogle(completion: @escaping () -> Void) {
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
                debugPrint(error.localizedDescription)
            }
            
            guard let user = result?.user, let token = user.idToken?.tokenString
            else {
                isLoading = false
                errorMessage = "Google token is empty."
                isError = true
                
                return
            }
            
            let credentials = GoogleAuthProvider.credential(withIDToken: token, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credentials) { [unowned self] result, error in
                isLoading = false
                
                if let error = error {
                    errorMessage = error.localizedDescription
                    isError = true
                    
                    return
                }
                
                completion()
            }
        }
        
    }
    
    func signUp(completion: @escaping () -> Void) {
        isValidEmail = checkEmail(email)
        isValidPassword = checkdPassword(password)
        
        guard isValidEmail && isValidPassword else { return  }
        
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] result, error in
            isLoading = false
            
            if let error = error {
                errorMessage = error.localizedDescription
                isError = true
            } else {
                
                Auth.auth().currentUser?.sendEmailVerification()
                
                completion()
            }
        }
    }
    
}

//MARK: - Extension with private methods

private extension AuthViewModel {
    
    func checkEmail(_ email: String) -> Bool {
        guard !email.isEmpty else { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return predicate.evaluate(with: email)
    }
    
    func checkdPassword(_ password: String) -> Bool {
        guard !password.isEmpty else { return false }
        
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return predicate.evaluate(with: password)
    }
    
}
