//
//  DrawView.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import SwiftUI
import PencilKit
import UIKit

struct DrawView: UIViewRepresentable {
    
    @Binding var selectedTab: ImageEditorFooter.ButtonType
    @Binding var canvasView: PKCanvasView
    @Binding var image: UIImage?
    
    private let toolPicker = PKToolPicker()
    private let imageView = UIImageView()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.isOpaque = false
        canvasView.drawingPolicy = .anyInput
        canvasView.drawing = PKDrawing()
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        let isSelecteTabDraw = selectedTab == .draw
        toolPicker.setVisible(isSelecteTabDraw, forFirstResponder: uiView)
        toolPicker.addObserver(uiView)
        toolPicker.colorUserInterfaceStyle = .dark
        
        if isSelecteTabDraw {
            uiView.becomeFirstResponder()
            uiView.isUserInteractionEnabled = true
        } else {
            uiView.isUserInteractionEnabled = false
            uiView.resignFirstResponder()
        }
    }
    
    typealias UIViewType = PKCanvasView

}
