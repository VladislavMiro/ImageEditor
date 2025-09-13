//
//  Filters.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import Foundation

enum Filters: Hashable, CaseIterable, CustomStringConvertible {
    case Original
    case BlackAndWhite
    case Sepia
    case Blur
    case Negative
    case Vintage
    
    var description: String {
        switch self {
        case .Original: "Original"
        case .BlackAndWhite: "Black And White"
        case .Sepia: "Sepia"
        case .Blur: "Blur"
        case .Negative: "Negative"
        case .Vintage: "Vintage"
        }
    }
}
