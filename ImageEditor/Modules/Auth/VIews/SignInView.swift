//
//  SignInView.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore
import FirebaseAuth

struct SignInView: View {
    
    @State private var isForgotPassword: Bool = false
    @State private var toMainView: Bool = false
    @State private var path = NavigationPath()
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            Text("Sign In")
                .font(.system(.largeTitle, weight: .bold))
                .foregroundStyle(Color.blue)
                .padding(.bottom, 80)
            
            VStack(alignment: .leading) {
                
                TextField(text: $viewModel.email, label: {
                    Text("Email")
                })
                .modifier(AuthTextField(isValid: $viewModel.isValidEmail))
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                
                if !viewModel.isValidEmail {
                    Text("Email is not valid")
                        .foregroundStyle(Color.red)
                        .padding(.leading, 16)
                }
                
                VStack(alignment: .trailing) {
                    SecureField("Password", text: $viewModel.password)
                        .modifier(AuthTextField(isValid: $viewModel.isValidPassword))
                        .keyboardType(.default)
                        .textContentType(.password)
                    
                    Button {
                        isForgotPassword.toggle()
                    } label: {
                        Text("Forgot password")
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    viewModel.signIn {
                        toMainView.toggle()
                    }
                } label: {
                    Text("Sign In")
                }
                .modifier(AuthButton())
                
                HStack(spacing: 1) {
                    Text("Don't have an account? ")
                    
                    NavigationLink("Sign Up", value: RoutingPaths.SignUpView)
                }
                .padding(.leading, 16)
                
                VStack(alignment: .center) {
                    Text("Or")
                    
                    GoogleSignInButton(style: .wide) {

                        viewModel.signInWithGoogle() {
                            toMainView.toggle()
                        }
                        
                    }
                }
                
            }
            .padding(.horizontal, 20)
            .alert("Error", isPresented:  $viewModel.isError, actions: {
                Button("OK") {}
            }, message: {
                Text(viewModel.errorMessage)
            })
            .navigationDestination(for: RoutingPaths.self) { path in
                switch path {
                case .SignUpView:
                    SignUpView(path: $path)
                        .environmentObject(viewModel)
                }
            }.sheet(isPresented: $isForgotPassword) {
                ResetPasswordView()
                    .environmentObject(viewModel)
            }.fullScreenCover(isPresented: $toMainView) {
                ContentView()
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
