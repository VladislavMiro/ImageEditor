//
//  SignUpView.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI

struct SignUpView: View {

    @Binding var path: NavigationPath
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.system(.largeTitle, weight: .bold))
                .foregroundStyle(Color.blue)
                .padding(.top, -80)
            
            VStack(alignment: .leading) {
                TextField("Email", text: $viewModel.email)
                    .modifier(AuthTextField(isValid: $viewModel.isValidEmail))
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                
                if !viewModel.isValidEmail {
                    Text("Email is not valid")
                        .foregroundStyle(Color.red)
                        .padding(.leading, 16)
                }
                
                SecureField("Password", text: $viewModel.password)
                    .modifier(AuthTextField(isValid: $viewModel.isValidPassword))
                    .keyboardType(.default)
                    .textContentType(.newPassword)
                
                if !viewModel.isValidPassword {
                    Text("Minimum 8 characters at least 1 Alphabet and 1 Number")
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.red)
                        .padding(.leading, 20)
                }
                
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            
            Button("Sign Up") {
                viewModel.signUp() {
                    path.removeLast()
                }
            }
            .modifier(AuthButton())
            .padding(.horizontal, 20)
            .alert("Error", isPresented: $viewModel.isError, actions: {
                Button("OK") {
                    
                }
            }, message: {
                Text(viewModel.errorMessage)
            })
        }.onAppear {
            viewModel.email = ""
            viewModel.password = ""
        }
    }
}

#Preview {
    let path = NavigationPath()
    SignUpView(path: .constant(path))
}
