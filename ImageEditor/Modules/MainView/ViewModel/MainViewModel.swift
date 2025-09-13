//
//  MainViewModel.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 13.09.2025.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import Photos

protocol MainViewModelProtocol: AnyObject, ObservableObject {
    
}

final class MainViewModel {
    
    @Published var photos: PHFetchResult<PHAsset> = .init()
    @Published var isAuthorized: Bool = false
    @Published var isSignOut: Bool = false
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    @Published var user = Auth.auth().currentUser
    @Published var selectedImage: UIImage?
    
}

//MARK: - Extension with MainViewModelProtocol implementation

extension MainViewModel: MainViewModelProtocol {
    
    func signOut() {
        do {
            GIDSignIn.sharedInstance.signOut()
            try Auth.auth().signOut()
            
            isSignOut = true
        } catch {
            errorMessage = error.localizedDescription
            isError = true
        }
    }
    
    func fetchPhotos() {
        Task(priority: .userInitiated) {
            let res = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            
            if res == .authorized {
                let fetchOptions = PHFetchOptions()
                
                isAuthorized = true
                
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                
                await MainActor.run {
                    photos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                }
            } else {
                isAuthorized = false
            }
        }
        
    }
    
    func getImageForCell(at index: Int, completion: @escaping ((UIImage?) -> Void)) {
        guard photos.count != 0 else { return }
        
        let asset = photos[index]
        
        let options = PHImageRequestOptions()
    
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
    
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: .init(width: 200, height: 200),
                                              contentMode: .aspectFill,
                                              options: options) { image, _ in
            if let image = image {
                completion(image)
            }
        }
    }
    
    func getOriginalImage(at index: Int) {
        let options = PHImageRequestOptions()
        
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.resizeMode = .none
        
        let asset = photos[index]
        
        PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { data, _, _, _ in
            if let data = data, let image = UIImage(data: data) {
                self.selectedImage = image
            }
        }
    }
    
}
