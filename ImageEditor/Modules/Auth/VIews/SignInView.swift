//
//  SignInView.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct SignInView: View {
    
    @State private var isForgotPassword: Bool = false
    @State private var path = NavigationPath()
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("Sign In")
                    .font(.system(.largeTitle, weight: .bold))
                    .foregroundStyle(Color.blue)
                    .padding(.vertical, 80)
                
                textFields
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                ProgressView()
                    .padding(.bottom, 20)
                    .opacity(viewModel.isLoading ? 1 : 0)
                
                buttons
                    .padding(.horizontal, 20)
                
                Spacer()
            }
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
                    .presentationDragIndicator(.visible)
            }.fullScreenCover(isPresented: $viewModel.isSignedIn) {
                MainView()
            }
        }
    }
    
    private var textFields: some View {
        VStack(alignment: .leading) {
            TextField(text: $viewModel.email, label: {
                Text("Email")
            })
            .modifier(AuthTextField(isValid: $viewModel.isEmailValid))
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)

            Text("Email is not valid")
                .foregroundStyle(Color.red)
                .padding(.leading, 16)
                .opacity(viewModel.isEmailValid ? 0 : 1)
            
            VStack(alignment: .trailing) {
                SecureField("Password", text: $viewModel.password)
                    .modifier(AuthTextField(isValid: .constant(true)))
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
    }
    
    private var buttons: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                viewModel.signIn()
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
                    viewModel.signInWithGoogle()
                }
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
