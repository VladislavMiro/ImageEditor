//
//  SignUpView.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI

struct SignUpView: View {

    @Binding var path: NavigationPath
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.system(.largeTitle, weight: .bold))
                .foregroundStyle(Color.blue)
                .padding(.vertical, 80)
            
            textFields
                .padding(.horizontal, 20)
            
            ProgressView()
                .padding(.bottom, 10)
                .opacity(viewModel.isLoading ? 1 : 0)
            
            Button("Sign Up") {
                viewModel.signUp()
            }
            .modifier(AuthButton())
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .ignoresSafeArea(.keyboard)
        .background(Color.white)
        .alert("Error", isPresented: $viewModel.isError, actions: {
            Button("OK") { }
        }, message: {
            Text(viewModel.errorMessage)
        })
        .onChange(of: viewModel.isSignedUp) { isSignedUp in
            if isSignedUp {
                path.removeLast()
            }
        }
        
    }
    
    private var textFields: some View {
        VStack(alignment: .leading) {
            TextField(text: $viewModel.email) {
                Text("Email")
                    .foregroundStyle(Color.gray)
            }
            .modifier(AuthTextField(isValid: $viewModel.isEmailValid))
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)

            Text("Email is not valid")
                .foregroundStyle(Color.red)
                .padding(.leading, 16)
                .opacity(viewModel.isEmailValid ? 0 : 1)
            
            SecureField(text: $viewModel.password) {
                Text("Password")
                    .foregroundStyle(Color.gray)
            }
            .modifier(AuthTextField(isValid: $viewModel.isPasswordValid))
            .keyboardType(.default)
            .textContentType(.newPassword)
            
            Text("Minimum 8 characters at least 1 Alphabet and 1 Number")
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.red)
                .padding(.leading, 16)
                .opacity(viewModel.isPasswordValid ? 0 : 1)
        }
    }
}

#Preview {
    let path = NavigationPath()
    
    SignUpView(path: .constant(path))
}
