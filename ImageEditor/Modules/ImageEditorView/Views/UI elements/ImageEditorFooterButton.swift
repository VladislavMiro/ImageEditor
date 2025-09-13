//
//  ImageEditorFooterButton.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 12.09.2025.
//

import SwiftUI

struct ImageEditorFooterButton: View {
    var image: String
    var title: String
    var actionHandler: (() -> Void)?
    
    var body: some View {
        Button {
            actionHandler?()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: image)
                Text(title)
            }.foregroundStyle(.white)
        }
    }
}

#Preview {
    ImageEditorFooterButton(image: "camera.filters", title: "filters")
}
