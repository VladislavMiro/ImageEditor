//
//  FilterFactoryProtocol.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 13.09.2025.
//

import UIKit

protocol FilterFactoryProtocol: AnyObject {
    func createBlaclAndWhiteFilter(for image: UIImage) -> UIImage?
    func createSepiaFilter(for image: UIImage) -> UIImage?
    func createBlurFilter(for image: UIImage) -> UIImage?
    func createNegativeFilter(for image: UIImage) -> UIImage?
    func createVintageFilter(for image: UIImage) -> UIImage?
}
