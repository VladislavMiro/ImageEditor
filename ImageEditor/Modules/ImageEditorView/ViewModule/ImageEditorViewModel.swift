//
//  ImageEditorViewModel.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import Foundation
import PencilKit
import Photos

final class ImageEditorViewModel: ObservableObject {
    
    @Published var image: UIImage
    @Published var texts: [UserText] = []
    @Published var renderedImage: UIImage
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isRendering: Bool = false
    
    private let filterFactory: FilterFactoryProtocol = FilterFactory()
    
    private var originalImage: UIImage
    
    
    init(image: UIImage) {
        self.image = image
        self.originalImage = image
        self.renderedImage = image
    }
    
}

//MARK: - Extension with ImageEditorViewModelProtocol implementation


extension ImageEditorViewModel {
    
    func addFilter(of type: Filters) {
        let image = originalImage
        var filteredImage: UIImage?
        
        switch type {
        case .Original:
            filteredImage = originalImage
        case .BlackAndWhite:
            filteredImage = filterFactory.createBlaclAndWhiteFilter(for: image)
        case .Sepia:
            filteredImage = filterFactory.createSepiaFilter(for: image)
        case .Blur:
            filteredImage = filterFactory.createBlurFilter(for: image)
        case .Negative:
            filteredImage = filterFactory.createNegativeFilter(for: image)
        case .Vintage:
            filteredImage = filterFactory.createVintageFilter(for: image)
        }
        
        if let filteredImage = filteredImage {
            self.image = filteredImage
        } else {
            errorMessage = "Filtering error."
            isError = true
        }
    }
    
    func appendText(_ text: UserText) {
        texts.append(text)
    }
    
    func clearTextIsEditingStates() {
        guard let index = texts.firstIndex(where: { $0.isEditing }) else { return }
        
        var item = texts[index]
        
        item.isEditing = false
        
        texts.remove(at: index)
        texts.insert(item, at: index)
    }
    
    func removeText(with id: UUID) {
        texts.removeAll { $0.id == id }
    }
    
    func changeTextParameters(font: String? = nil, size: CGFloat? = nil, color: UIColor? = nil) {
        guard let index = texts.firstIndex(where: { $0.isEditing }) else { return }
        
        var item = texts[index]
        
        item.font = font ?? item.font
        item.color = color ?? item.color
        item.size = size ?? item.size
        
        texts.remove(at: index)
        texts.insert(item, at: index)
    }
    
    func save(drawing: PKDrawing) {
        let image = self.renderImage(drawing: drawing)
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetCreationRequest.forAsset()
            
            if let data = image.jpegData(compressionQuality: 0.9) {
                request.addResource(with: .photo, data: data, options: nil)
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Save not completed. Unsoecified error."
                    self.isError = true
                }
            }
        } completionHandler: { _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                }
            }
        }
    }
    
    func renderImage(drawing: PKDrawing) -> UIImage {
        let fmt = UIGraphicsImageRendererFormat()

        fmt.scale = 1.0
        
        let renderer = UIGraphicsImageRenderer(size: image.size, format: fmt)
    
        let drawing = drawing.image(from: .init(origin: .zero, size: image.size), scale: 1.0)
        
        let combineImage = renderer.image { context in
            
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            drawText()
            
            
            drawing.draw(in: CGRect(origin: .zero, size: image.size))
            
            isRendering = false
        }
        
        return combineImage
    }
    
    
}

//MARK: - Extension with private methods

private extension ImageEditorViewModel {
    
    func drawText() {
        self.texts.forEach { text in
            
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.alignment = .center
            
            //let fontSize = image.size.widht / 0.05
            
            let attrs: [NSAttributedString.Key : Any] = [
                .font : UIFont(name: text.font, size: CGFloat(text.size)) ?? .systemFont(ofSize: CGFloat(text.size)),
                .foregroundColor : text.color,
                .paragraphStyle : paragraphStyle
            ]
            
            let nsText = NSString(string: text.text)
            let textSize = nsText.size(withAttributes: attrs)
            
            let textRect = CGRect(x: text.position.x,
                                  y: text.position.y,
                                  width: textSize.width,
                                  height: textSize.height)
            
            nsText.draw(in: textRect, withAttributes: attrs)
        }
    }
    
}
