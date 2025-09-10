//
//  AuthButton.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI

struct AuthButton: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(Color.blue)
            .cornerRadius(16)
            .foregroundStyle(Color.white)
            .font(.system(.title2, weight: .regular))
    }
    
}

