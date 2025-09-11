//
//  CredentialsValidatorProtocol.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import Foundation

protocol CredentialsValidatorProtocol {
    static func emailIsValid(email: String) -> Bool
    static func passwordIsValid(password: String) -> Bool
}
