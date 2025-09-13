//
//  FilterFactory.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

final class FilterFactory {
    
}

//MARK: - Extension with FilterManagerProtocol implementation

extension FilterFactory: FilterFactoryProtocol {
    
    func createBlaclAndWhiteFilter(for image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let filter = CIFilter.photoEffectNoir()
        
        filter.inputImage = ciImage
        
        return createImage(with: filter, original: image)
    }
    
    func createSepiaFilter(for image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let filter = CIFilter.sepiaTone()
        
        filter.inputImage = ciImage
        filter.intensity = 1.0
        
        return createImage(with: filter, original: image)
    }
    
    func createBlurFilter(for image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let filter = CIFilter.bokehBlur()
        
        filter.inputImage = ciImage
        filter.ringSize = 0.1
        filter.ringAmount = 0.0
        filter.softness = 1.0
        filter.radius = 20
        
        return createImage(with: filter, original: image)
    }
    
    func createNegativeFilter(for image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let filter = CIFilter.colorInvert()
        
        filter.inputImage = ciImage
    
        return createImage(with: filter, original: image)
    }
    
    func createVintageFilter(for image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let filter = CIFilter.photoEffectChrome()
        
        filter.inputImage = ciImage
    
        return createImage(with: filter, original: image)
    }
    
}

//MARK: - Extension with private methods

private extension FilterFactory {
    
    func createImage(with filter: CIFilter, original: UIImage) -> UIImage? {
        let context = CIContext()
        
        if let outputImage = filter.outputImage,
            let data = context.createCGImage(outputImage, from: outputImage.extent) {
            
            return UIImage(cgImage: data, scale: original.scale, orientation: original.imageOrientation)
        } else {
            return nil
        }
    }
    
}
