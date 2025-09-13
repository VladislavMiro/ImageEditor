//
//  MainViewModelProtocol.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 14.09.2025.
//

import Foundation
import Photos
import UIKit

protocol MainViewModelProtocol: AnyObject, ObservableObject {
    var photos: PHFetchResult<PHAsset> { get set }
    var isAuthorized: Bool { get set }
    var isSignOut: Bool { get set }
    var isError: Bool { get set }
    var errorMessage: String { get set }
    var selectedImage: UIImage? { get set }
    
    func signOut()
    func fetchPhotos()
    func getImageForCell(at index: Int, completion: @escaping ((UIImage?) -> Void))
    func getOriginalImage(at index: Int)
}
