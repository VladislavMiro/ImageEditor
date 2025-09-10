//
//  GoogleSignInViewProxy.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI
import UIKit

final class GoogleSignInViewProxy {
    
    private var view: AnyView
    
    init(view: AnyView) {
        self.view = view
    }
    
    func getViewController() -> UIViewController {
        let hostingVC = UIHostingController(rootView: view)
        return hostingVC
    }
    
}
