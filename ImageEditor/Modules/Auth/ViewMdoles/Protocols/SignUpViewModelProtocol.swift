//
//  SignUpViewModelProtocol.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import Foundation

protocol SignUpViewModelProtocol: AnyObject, ObservableObject {
    var email: String { get set }
    var password: String { get set }
    var errorMessage: String { get }
    var isError: Bool { get }
    var isLoading: Bool { get }
    var isSignedUp: Bool { get }
    var isPasswordValid: Bool { get }
    var isEmailValid: Bool { get }
    
    func signUp()
}
