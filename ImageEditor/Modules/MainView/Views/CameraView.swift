//
//  CameraView.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    
    @Binding private var isPresent: Bool
    @Binding private var image: UIImage?
    
    init(isPresent: Binding<Bool>, image: Binding<UIImage?>) {
        self._image = image
        self._isPresent = isPresent
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let view = UIImagePickerController()
        
        view.delegate = context.coordinator
        view.sourceType = .camera
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> CameraViewCoordinator {
        return CameraViewCoordinator(isPresent: $isPresent, image: $image)
    }
    
    typealias UIViewControllerType = UIImagePickerController
    
    
}

//MARK: - Extension with subobjects

extension CameraView {
    
    final class CameraViewCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        @Binding private var isPresent: Bool
        @Binding private var image: UIImage?
        
        init(isPresent: Binding<Bool>, image: Binding<UIImage?>) {
            self._isPresent = isPresent
            self._image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            self.image = image
            
            isPresent = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isPresent = false
        }
        
    }
    
}
