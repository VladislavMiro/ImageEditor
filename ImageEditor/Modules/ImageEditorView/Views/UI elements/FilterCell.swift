//
//  FilterCell.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import SwiftUI

struct FilterCell: View {
    var title: String
    var isSelected: Bool

    var body: some View {
        VStack {
            Text(title)
                .padding()
                .foregroundStyle(.white)
        }
        .background(Color.black)
        .cornerRadius(16.0)
        .overlay(
            RoundedRectangle(cornerRadius: 16.0)
                .strokeBorder(isSelected ? Color.white : Color.black)
        )

        
    }
}

#Preview {
    FilterCell(title: "Original", isSelected: true)
}
