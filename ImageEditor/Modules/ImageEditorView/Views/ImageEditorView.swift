//
//  MainView.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI
import PhotosUI
import PencilKit

struct ImageEditorView: View {
    
    @EnvironmentObject private var viewModel: ImageEditorViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var zoomScale: CGFloat = 0.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var canvas = PKCanvasView()
    @State private var selectedTab: ImageEditorFooter.ButtonType = .none
    @State private var isDoneButton: Bool = false
    @State private var isSaveButton: Bool = false
    
    @FocusState private var focusState: Bool
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                Image(uiImage: viewModel.image)
                    .resizable()
                    .scaledToFit()
                    .gesture(imageGesture)
                    .overlay {
                        DrawView(selectedTab: $selectedTab,
                                 canvasView: $canvas)
                    }
                    .overlay {
                        textfieldForImage
                    }
                    .scaleEffect(scale)
                    .offset(offset)
                    .animation(.easeInOut, value: scale)
                    .animation(.easeInOut, value: offset)
                
                VStack {
                    Spacer()
                    
                    ImageEditorFooter(selectedTab: $selectedTab)
                        .environmentObject(viewModel)
                }
            }
            .sheet(isPresented: $isSaveButton) {
                saveView
            }
            .alert("Error", isPresented: $viewModel.isError) {
                Button("OK") {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.white)
                    }
                    .opacity(isDoneButton ? 0 : 1)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        saveButtonTapped()
                    } label: {
                        if isDoneButton {
                            Text("Done")
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "externaldrive.fill")
                                .foregroundStyle(.white)
                        }
                    }
                }
            })
            .toolbarBackground(.lightBlack, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .ignoresSafeArea(.keyboard)
        }
        .onChange(of: selectedTab) { selectedTab in
            selectedTabDidChanged(selectedTab)
        }
    }
    
    private var saveView: some View {
        VStack(alignment: .center) {
            let preview = SharePreview("Check my image", image: Image(uiImage: viewModel.renderedImage))
            let data = SharedImage(image: viewModel.renderedImage)
            
            Group {
                Divider()
                
                ShareLink(item: data, preview: preview) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                    .foregroundStyle(Color.white)
                }
                
                Divider()
                
                Button("Save to Photos") {
                    viewModel.save(drawing: canvas.drawing)
                    isSaveButton.toggle()
                }
                
                Divider()
                
                Button("Cancel") {
                    isSaveButton.toggle()
                }
                
                Divider()
            }
            .frame(height: 30)
            .foregroundStyle(.white)
            
        }
        .ignoresSafeArea()
        .presentationDetents([.height(250)])
    }
    
    private var imageGesture: some Gesture {
        MagnificationGesture()
            .onChanged({ state in
                let delta = state / lastScale
                let newScale = scale * delta
                
                zoomScale = min(max(newScale, 1.0), 5.0)
                scale = zoomScale
                
                lastScale = state
            }).onEnded({ state in
                lastScale = 1.0
            })
            .simultaneously(with:
                                DragGesture()
                .onChanged({ value in
                    let newOffset = CGSize(
                        width: lastOffset.width + value.translation.width,
                        height: lastOffset.height + value.translation.height)
                    
                    offset = newOffset
                })
                    .onEnded({ value in
                        lastOffset = offset
                    })
            )
    }
    
    private var textfieldForImage: some View {
        ZStack {
            ForEach($viewModel.texts) { $item in
                TextField("", text: $item.text, onEditingChanged: { _ in
                    if !focusState {
                        viewModel.clearTextIsEditingStates()
                        item.isEditing = true
                        selectedTab = .text
                    }
                }, onCommit: {
                    item.isEditing = false
                    selectedTab = .none
                })
                .tag(item.id)
                .fixedSize(horizontal: true, vertical: false)
                .border(Color(uiColor: item.color),
                        width: item.isEditing ? 1 : 0)
                .font(.custom(item.font, size: CGFloat(item.size)))
                .foregroundStyle(Color(uiColor: item.color))
                .focused($focusState)
                .onTapGesture {
                    item.isEditing = true
                    selectedTab = .text
                }
                .overlay  {
                    GeometryReader { geo in
                        Button {
                            focusState = false
                            viewModel.removeText(with: item.id)
                        }
                        label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundStyle(Color.red)
                        }
                        .position(x: geo.size.width)
                    }.opacity(item.isEditing ? 1 : 0)
                }
                .position(item.position)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            item.position = value.location
                        }
                )
            }
        }
    }
}

//MARK: - Extension with private methods

private extension ImageEditorView {
    
    func saveButtonTapped() {
        switch selectedTab {
        case .draw:
            selectedTab = .none
        case .text:
            viewModel.clearTextIsEditingStates()
            focusState = false
            selectedTab = .none
        default:
            isSaveButton = true
        }
    }
    
    func selectedTabDidChanged(_ selectedTab: ImageEditorFooter.ButtonType) {
        isDoneButton = selectedTab == .draw || selectedTab == .text
    }
    
}

#Preview {
    ImageEditorView()
}
