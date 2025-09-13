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
    @Binding var drawing: PKDrawing
    private let toolPicker = PKToolPicker()
    private let imageView = UIImageView()
    @Binding var scale: CGFloat
    @Binding var canvasView: PKCanvasView
    @Binding var image: UIImage?
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.isOpaque = false
        canvasView.drawingPolicy = .anyInput
        canvasView.delegate = context.coordinator
        canvasView.drawing = drawing
        
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
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvas: self)
    }
    
    typealias UIViewType = PKCanvasView

}

//MARK: - Extension with subobjects

extension DrawView  {
    
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        private var canvas: DrawView
        
        init(canvas: DrawView) {
            self.canvas = canvas
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            canvas.drawing = canvasView.drawing
        }
    }
    
}
