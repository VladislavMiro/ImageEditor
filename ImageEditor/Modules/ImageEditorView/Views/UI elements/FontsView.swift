//
//  FontsList.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 12.09.2025.
//

import SwiftUI

struct FontsView: View {
    
    @State private var fonts: [String] = UIFont.familyNames
    @State private var selectedFont = "Arial"
    @State private var selectedSize: CGFloat = 20
    @State private var selectedColor: Color = .black
    @EnvironmentObject private var viewModel: ImageEditorViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Font:")
                        
                        Picker("Font", selection: $selectedFont) {
                            ForEach(fonts, id: \.self) { item in
                                Text(item)
                                    .tag(item)
                            }
                            .pickerStyle(.segmented)
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                    .padding(.bottom, 10)
                    
                    Stepper("Font Size:     \(Int(selectedSize))",
                            value: $selectedSize, in: 0...128, step: 1)
                        .foregroundStyle(.white)

                }
                
                Divider()
                    .background(Color.white)
                
                VStack {
                    Button {
                        addButtonPressed()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundStyle(Color.white)
                    }
                    .frame(width: 25, height: 25)
                    .padding(.leading, 5)
                    
                    ColorPicker("", selection: $selectedColor)
                        .frame(width: 20, height: 20)
                        .padding()
                }
                
            }
            .padding()
            
        }
        .background {
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 16,
                                                      topTrailing: 16))
            .fill(Color.lightBlack)
        }
        .foregroundStyle(.white)
        .onChange(of: selectedFont) { selectedFont in
            viewModel.changeTextParameters(font: selectedFont)
        }.onChange(of: selectedSize) { selectedSize in
            viewModel.changeTextParameters(size: selectedSize)
        }.onChange(of: selectedColor) { selectedColor in
            viewModel.changeTextParameters(color: UIColor(selectedColor))
        }

    }
}

//MARK: - Extension with private methods

private extension FontsView {
    
    func addButtonPressed() {
        if let item = viewModel.texts.last {
            viewModel.clearTextIsEditingStates()
            
            let position = CGPoint(x: item.position.x + 15,
                                   y: item.position.y + 15)
            
            let text = UserText(id: UUID(),
                                text: "Example Text",
                                font: selectedFont,
                                size: selectedSize,
                                color: UIColor(selectedColor),
                                isEditing: true,
                                position: position)
            
            viewModel.appendText(text)
        } else {
            let text = UserText(id: UUID(),
                                text: "Example Text",
                                font: selectedFont,
                                size: selectedSize,
                                color: UIColor(selectedColor),
                                isEditing: true,
                                position: .init(x: 100, y: 100))
            
            viewModel.appendText(text)
        }
    }
    
}

#Preview {
    FontsView()
        .environmentObject(ImageEditorViewModel(image: .init()))
}
