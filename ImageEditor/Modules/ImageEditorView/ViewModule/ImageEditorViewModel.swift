//
//  ImageEditorViewModel.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import Foundation
import PencilKit

final class ImageEditorViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var texts: [UserText] = []
    
    private let filterFactory: FilterFactoryProtocol = FilterFactory()
    
    var originalImage: UIImage?
    
    init(image: UIImage? = nil, originalImage: UIImage? = nil) {
        self.image = image
    }
    
}

//MARK: - Extension with ImageEditorViewModelProtocol implementation


extension ImageEditorViewModel {
    
    func addFilter(of type: Filters) {
        guard let image = self.originalImage else { return }
        
        switch type {
        case .Original:
            self.image = originalImage
        case .BlackAndWhite:
            let image = filterFactory.createBlaclAndWhiteFilter(for: image)
            self.image = image
        case .Sepia:
            let image = filterFactory.createSepiaFilter(for: image)
            self.image = image
        case .Blur:
            let image = filterFactory.createBlurFilter(for: image)
            self.image = image
        case .Negative:
            let image = filterFactory.createNegativeFilter(for: image)
            self.image = image
        case .Vintage:
            let image = filterFactory.createVintageFilter(for: image)
            self.image = image
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
    
    func save(drawing: PKDrawing, canvasWidth: CGFloat) {
        DispatchQueue.main.async {
            guard let image = self.renderImage(drawing: drawing, canvasWidth: canvasWidth) else { return }
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }

    }
    
    
    
}

//MARK: - Extension with private methods

private extension ImageEditorViewModel {
    
    func renderImage(drawing: PKDrawing, canvasWidth: CGFloat) -> UIImage? {
        guard let image = image else { return nil }
        
        let fmt = UIGraphicsImageRendererFormat()

        fmt.scale = 1.0
        
        let renderer = UIGraphicsImageRenderer(size: image.size, format: fmt)
        
        let scale = image.size.width / canvasWidth
        let drawing = drawing.image(from: .init(origin: .zero, size: image.size), scale: 1.0)
        
        let combineImage = renderer.image { context in
            
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            
            drawText()
            
            
            drawing.draw(in: CGRect(origin: .zero, size: image.size))
            
            
        }
        
        return combineImage
    }
    
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
