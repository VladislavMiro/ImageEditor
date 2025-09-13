//
//  MainView.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 13.09.2025.
//

import SwiftUI
import PhotosUI

struct MainView: View {
    
    //MARK: - Private properties
    
    @StateObject private var viewModel = MainViewModel()
    
    @Environment(\.dismiss) private var dismiss

    @State private var isCameraOpened: Bool = false
    @State private var isImageEditorOpened: Bool = false
    @State private var path: NavigationPath = .init()
    
    //MARK: - UI elements
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                
                Text("You need to get access to your photo library in the settings.")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .opacity(!viewModel.isAuthorized ? 1 : 0)
                
                ScrollView {
                    LazyVGrid(columns: Array(
                        repeating: GridItem(.flexible(minimum: 100,
                                                      maximum: 200),
                                            spacing: 2),
                        count: 3)) {
                            
                        ForEach(0..<viewModel.photos.count, id: \.self) { index in
                            MainViewCell(index: index)
                                .environmentObject(viewModel)
                                .onTapGesture {
                                    viewModel.getOriginalImage(at: index)
                                }
                        }
                    }
                                             .background(Color.black)
                }
                .navigationTitle("Library")
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            viewModel.signOut()
                        } label: {
                            HStack {
                                Image(systemName: "door.left.hand.open")
                                Text("SignOut")
                            }
                            .foregroundColor(.white)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isCameraOpened = true
                        } label: {
                            Image(systemName: "camera")
                                .foregroundColor(.white)
                        }
                    }
                })
                .toolbarBackground(.lightBlack, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    viewModel.fetchPhotos()
                }
            }
        }
        .alert("Error", isPresented: $viewModel.isError, actions: {
            Button("OK") {  }
        }, message: {
            Text(viewModel.errorMessage)
        })
        .fullScreenCover(isPresented: $isImageEditorOpened) {
            ImageEditorView()
                .environmentObject(ImageEditorViewModel(image: viewModel.selectedImage,
                                                        originalImage: viewModel.selectedImage))
        }
        .fullScreenCover(isPresented: $isCameraOpened) {
            CameraView(isPresent: $isCameraOpened, image: $viewModel.selectedImage)
                .ignoresSafeArea()
        }
        .onChange(of: viewModel.selectedImage) { selectedImage in
            if let _ = selectedImage {
                isImageEditorOpened = true
            }
        }
        .fullScreenCover(isPresented: $viewModel.isSignOut, content: {
            SignInView()
        })
    
    }
}

#Preview {
    MainView()
}
