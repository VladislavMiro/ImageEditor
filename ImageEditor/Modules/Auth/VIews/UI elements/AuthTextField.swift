//
//  AuthTextField.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI

struct AuthTextField: ViewModifier {
    
    @Binding private var isValid: Bool
    
    init(isValid: Binding<Bool>) {
        self._isValid = isValid
    }
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 50)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isValid ? Color.black : Color.red)
            })
    }
    
}
