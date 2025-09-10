//
//  AuthRouter.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI

protocol AuthRouterProtocol: AnyObject {

    func showSignUpView()
    
}

final class AuthRouter {
    
    //MARK: - Public properties
    
    private(set) var path: NavigationPath = NavigationPath()
    
}


extension AuthRouter: AuthRouterProtocol {
    
    public func showSignUpView() {

    }
    
}
