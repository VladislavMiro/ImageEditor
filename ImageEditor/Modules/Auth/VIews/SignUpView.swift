//
//  SignUpView.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var path: NavigationPath
    
    var body: some View {
        Text("Sign Up")
            .font(.system(.largeTitle, weight: .bold))
            .foregroundStyle(Color.blue)
            .padding(.top, -80)
        
        VStack {
            TextField("Email", text: $email)
                .modifier(AuthTextField())
            
            SecureField("Password", text: $password)
                .modifier(AuthTextField())
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        
        Button("Sign Up") {
            path.removeLast()
        }
        .modifier(AuthButton())
        .padding(.horizontal, 20)
    }
}

#Preview {
    let path = NavigationPath()
    SignUpView(path: .constant(path))
}
