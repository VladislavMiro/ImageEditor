//
//  PhotoButton.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import SwiftUI

struct PhotoButton: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: 50)
            .foregroundStyle(.blue)
            .background(Color.lightBlack)
            .cornerRadius(16.0)
    }
    
}
