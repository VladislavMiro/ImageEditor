//
//  ResetPasswordView.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @StateObject private var viewModel = ResetPasswordViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Enter your email to reset password.")
                .foregroundStyle(Color.black)
                .padding(.vertical, 80)
            
            VStack(alignment: .leading) {
                TextField(text: $viewModel.email) {
                    Text("Email")
                        .foregroundStyle(Color.gray)
                }
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .modifier(AuthTextField(isValid: $viewModel.isValidEmail))
                    
                Text("Email is not valid")
                    .foregroundStyle(Color.red)
                    .padding(.leading, 16)
                    .opacity(viewModel.isValidEmail ? 0 : 1)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            ProgressView()
                .padding(.bottom, 20)
                .opacity(viewModel.isLoading ? 1 : 0)
            
            Button {
                viewModel.resetPassword()
            } label: {
                Text("Reset password")
            }
            .modifier(AuthButton())
            .padding(.horizontal, 20)
            Spacer()
        }
        .background(Color.white)
        .ignoresSafeArea(.keyboard)
        .alert("Password reset", isPresented: $viewModel.isPassworReset, actions: {
            Button("OK") {
                dismiss()
            }
        }, message: {
            Text("An email has been sent to reset your password.")
        })
        .alert("Error", isPresented: $viewModel.isError, actions: {
            Button("OK") {}
        }, message: {
            Text(viewModel.errorMessage)
        })
        
    }
}

#Preview {
    ResetPasswordView()
}
