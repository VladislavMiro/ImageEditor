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
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    private let filterFactory: FilterFactoryProtocol = FilterFactory()
    
    private var originalImage: UIImage
    
    
    init(image: UIImage) {
        self.image = image
        self.originalImage = image
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
        
        texts[index].isEditing = false
    }
    
    func removeText(with id: UUID) {
        guard !texts.isEmpty else { return }
        guard let index = texts.firstIndex(where: { $0.id == id }) else { return }
        
        Task(priority: .userInitiated) {
            await MainActor.run {
                texts.remove(at: index)
            }
        }
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
    
    func save(drawing: PKDrawing, canvasSizie: CGSize) {
        let image = renderImage(drawing: drawing, canvasSize: canvasSizie)
        
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
    
    func renderImage(drawing: PKDrawing, canvasSize: CGSize) -> UIImage {
        let effectiveCanvasSize: CGSize = (canvasSize.width > 0 && canvasSize.height > 0) ? canvasSize : image.size
        
        let fmt = UIGraphicsImageRendererFormat()
        
        fmt.scale = image.scale
        
        let renderer = UIGraphicsImageRenderer(size: image.size, format: fmt)
        
        let drawingImage = drawing.image(from: CGRect(origin: .zero, size: effectiveCanvasSize),
                                         scale: UIScreen.main.scale)
        
        let combined = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            drawText(onImageSize: image.size, canvasSize: effectiveCanvasSize)
            
            drawingImage.draw(in: CGRect(origin: .zero, size: image.size))
        }
        
        return combined
    }
    
    
}

//MARK: - Extension with private methods

private extension ImageEditorViewModel {
    
    func drawText(onImageSize imageSize: CGSize, canvasSize: CGSize) {
        let scaleX = imageSize.width / canvasSize.width
           let scaleY = imageSize.height / canvasSize.height
           let scale = min(scaleX, scaleY) 

           for text in texts {
               // Позиция
               let mappedX = text.position.x * scaleX
               let mappedY = text.position.y * scaleY

               // Масштабируем размер шрифта
               let fontSize = CGFloat(text.size) * scale

               let paragraphStyle = NSMutableParagraphStyle()
               paragraphStyle.alignment = .center

               let attrs: [NSAttributedString.Key : Any] = [
                   .font: UIFont(name: text.font, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
                   .foregroundColor: text.color,
                   .paragraphStyle: paragraphStyle
               ]

               let nsText = NSString(string: text.text)
               let textSize = nsText.size(withAttributes: attrs)

               let textRect = CGRect(
                    x: mappedX - textSize.width / 2,
                    y: mappedY - textSize.height / 2,
                   width: textSize.width,
                   height: textSize.height
               )

               nsText.draw(in: textRect, withAttributes: attrs)
           }
    }
    
}
