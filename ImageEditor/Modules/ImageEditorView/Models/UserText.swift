//
//  UserText.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 13.09.2025.
//

import UIKit

struct UserText: Hashable, Identifiable {
    let id: UUID
    var text: String
    var font: String
    var size: CGFloat
    var color: UIColor
    var isEditing: Bool
    var position: CGPoint
}
