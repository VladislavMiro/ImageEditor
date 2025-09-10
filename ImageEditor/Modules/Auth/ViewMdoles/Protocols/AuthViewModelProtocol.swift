//
//  AuthViewModelProtocol.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import Foundation

protocol AuthViewModelProtocol: AnyObject, ObservableObject {
    var email: String { get }
    var password: String { get }
    var errorMessage: String { get }
    var isError: Bool { get }
    var isValidEmail: Bool { get }
    var isValidPassword: Bool { get }
    
    func login(email: String, password: String)
    func signUp(completion: @escaping () -> Void)
    func resetPassword(completion: @escaping () -> Void)
}
