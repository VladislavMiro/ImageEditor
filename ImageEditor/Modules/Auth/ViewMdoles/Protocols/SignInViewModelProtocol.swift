//
//  SignInViewModelProtocol.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import Foundation

protocol SignInViewModelProtocol: AnyObject, ObservableObject {
    var email: String { get set }
    var password: String { get set }
    var errorMessage: String { get }
    var isError: Bool { get }
    var isEmailValid: Bool { get }
    
    func signIn()
    func signInWithGoogle()
}
