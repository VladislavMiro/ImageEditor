//
//  ShareData.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 14.09.2025.
//

import SwiftUI

struct SharedImage: Transferable {
    var image: Image
    var imageData: Data
    init(image: UIImage) {
        self.image = Image(uiImage: image)
        self.imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
    }
    
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
        DataRepresentation(exportedContentType: .image) { data in
            data.imageData
        }
    }
    
}
