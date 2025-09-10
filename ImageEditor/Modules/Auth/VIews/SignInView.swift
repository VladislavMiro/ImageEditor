//
//  SignInView.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI

struct SignInView: View {
    
    @State private var isForgotPassword: Bool = false
    @State private var path = NavigationPath()
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            Text("Sign In")
                .font(.system(.largeTitle, weight: .bold))
                .foregroundStyle(Color.blue)
                .padding(.top, -80)
            
            VStack(alignment: .trailing) {
                TextField(text: $viewModel.email, label: {
                    Text("Email")
                })
                .modifier(AuthTextField(isValid: $viewModel.isValidEmail))
                .keyboardType(.emailAddress)
                
                SecureField("Password", text: $viewModel.password)
                    .modifier(AuthTextField(isValid: $viewModel.isValidPassword))
                    .keyboardType(.default)
                
                Button {
                    isForgotPassword.toggle()
                } label: {
                    Text("Forgot password")
                }
                .padding(.horizontal, 16)
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
                    
                    NavigationLink("Sign Up", value: RoutingPaths.SignUpView)
                }
                .padding(.leading, 16)
            }
            .padding(.horizontal, 20)
            .navigationDestination(for: RoutingPaths.self) { path in
                switch path {
                case .SignUpView:
                    SignUpView(path: $path)
                        .environmentObject(viewModel)
                }
            }.sheet(isPresented: $isForgotPassword) {
                ResetPasswordView()
                    .environmentObject(viewModel)
            }
        }
    }
}

//MARK: - Extension with private subobjects

private extension SignInView {
    
    enum RoutingPaths: Hashable {
        case SignUpView
    }
    
}

#Preview {
    SignInView()
}
