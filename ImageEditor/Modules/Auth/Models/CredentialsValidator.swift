//
//  CredentialsValidator.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import Foundation

struct CredentialsValidator: CredentialsValidatorProtocol {
   
    static func emailIsValid(email: String) -> Bool {
        guard !email.isEmpty else { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return predicate.evaluate(with: email)
    }
    
    static func passwordIsValid(password: String) -> Bool {
        guard !password.isEmpty else { return false }
        
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return predicate.evaluate(with: password)
    }
    
}
