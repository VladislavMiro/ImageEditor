//
//  ImageEditorApp.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI
import FirebaseAuth

@main
struct ImageEditorApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            //if Auth.auth().currentUser != nil {
              //  ContentView()
            //} else {
                SignInView()
            //}
        }
    }
}
