//
//  ResetPasswordViewModelProtocol.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import Foundation

protocol ResetPasswordViewModelProtocol: AnyObject, ObservableObject {
    var email: String { get set }
    var isLoading: Bool { get }
    var isValidEmail: Bool { get }
    var errorMessage: String { get }
    var isError: Bool { get }
    var isPassworReset: Bool { get }
    
    func resetPassword()
}
