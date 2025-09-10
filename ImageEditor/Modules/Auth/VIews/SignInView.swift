//
//  SignInView.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI

struct SignInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        Text("Sign In")
            .font(.system(.largeTitle, weight: .bold))
            .foregroundStyle(Color.blue)
            
        VStack(alignment: .trailing) {
            TextField(text: $email, label: {
                Text("Email")
            })
            .modifier(AuthTextField())
            .keyboardType(.emailAddress)

            SecureField("Password", text: $password)
                .modifier(AuthTextField())
                .keyboardType(.default)
            
            Button {
                
            } label: {
                Text("Forgot password")
            }.padding(.horizontal, 16)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 15)
        
        VStack(alignment: .leading, spacing: 10) {
            Button {
                
            } label: {
                Text("Sign In")
            }
            .modifier(AuthButton())
            
            HStack(spacing: 1) {
                Text("Don't have an account? ")
                
                Button {
                    
                } label: {
                    Text("Sign Up")
                }
            }
            .padding(.leading, 16)
        }
        .padding(.horizontal, 20)

        }
}

#Preview {
    SignInView()
}
