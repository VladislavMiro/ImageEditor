//
//  AppDelegate.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import UIKit
import FirebaseCore

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
    
}
