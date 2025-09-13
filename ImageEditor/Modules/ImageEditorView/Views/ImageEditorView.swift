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
    
    @StateObject private var viewModel = ImageEditorViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var isCameraOpened: Bool = false
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var drawing = PKDrawing()
    @State private var imageSize: CGSize = .zero
    @State private var imageFrame: CGSize = .zero
    @State private var canvas = PKCanvasView()
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var selectedTab: ImageEditorFooter.ButtonType = .none
    @State private var zoomScale: CGFloat = 0.0
    @State private var cancelOpacity = 1.0
    @State private var saveButtonTite: String = "Save"
    
    @FocusState private var focusState: Bool
    
    var body: some View {
        NavigationStack {
            
            if viewModel.image == nil {
                selectPhotoView
            } else {
                imageEditor
            }
            
        }
        .fullScreenCover(isPresented: $isCameraOpened) {
            CameraView(isPresent: $isCameraOpened, image: $viewModel.image)
                .ignoresSafeArea()
        }
        .onChange(of: pickerItem) { pickerItem in
            Task {
                if let image = try? await pickerItem?.loadTransferable(type: Data.self) {
                    viewModel.image = UIImage(data: image)
                    viewModel.originalImage = UIImage(data: image)
                } else {
                    debugPrint("ddd")
                }
            }
        }
        .onChange(of: selectedTab) { selectedTab in
            selectedTabDidChanged(selectedTab)
        }
    }
    
    private var imageEditor: some View {
        VStack(alignment: .leading) {
            GeometryReader { geo in
                ZStack(alignment: .center) {
                    Image(uiImage: viewModel.image ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .gesture(
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
                                .simultaneously(with: DragGesture()
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
                        )
                        .overlay {
                            DrawView(selectedTab: $selectedTab,
                                     drawing: $drawing,
                                     scale: $scale,
                                     canvasView: $canvas,
                                     image: $viewModel.image)
                            
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
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    
                } label: {
                    Text("Cancel")
                        .foregroundColor(.white)
                }
                .opacity(cancelOpacity)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    saveButtonTapped()
                } label: {
                    Text(saveButtonTite)
                        .foregroundColor(.white)
                }
            }
        })
        .toolbarBackground(.lightBlack, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity)
        .background(Color.black)
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
    
    private var selectPhotoView: some View {
        VStack(spacing: 16) {
            
            PhotosPicker(selection: $pickerItem, matching: .images, preferredItemEncoding: .current) {
                HStack {
                    Image(systemName: "photo.on.rectangle.angled")
                    Text("Choose a photo")
                    Spacer()
                }.padding()
            }
            .modifier(PhotoButton())
            
            Button {
                isCameraOpened = true
            } label: {
                HStack {
                    Image(systemName: "camera")
                    Text("Take a photo")
                    Spacer()
                }.padding()
            }
            .modifier(PhotoButton())
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Editor")
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
            viewModel.save(drawing: drawing, canvasWidth: canvas.bounds.width)
        }
    }
    
    func selectedTabDidChanged(_ selectedTab: ImageEditorFooter.ButtonType) {
        if selectedTab == .draw || selectedTab == .text {
            cancelOpacity = 0
            saveButtonTite = "Done"
        } else {
            cancelOpacity = 1
            saveButtonTite = "Save"
        }
    }
    
}

#Preview {
    ImageEditorView()
}
