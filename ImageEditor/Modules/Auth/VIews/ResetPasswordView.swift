//
//  ResetPasswordView.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 10.09.2025.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var passwordIsReset: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Enter your email to reset password.")
                .padding(.bottom, 80)
            
            VStack(alignment: .leading) {
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .modifier(AuthTextField(isValid: $viewModel.isValidEmail))
                    
                if !viewModel.isValidEmail {
                    Text("Email is not valid")
                        .foregroundStyle(Color.red)
                        .padding(.leading, 16)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            
            Button {
                viewModel.resetPassword {
                    passwordIsReset.toggle()
                }
            } label: {
                Text("Reset password")
            }
            .modifier(AuthButton())
            .padding(.horizontal, 20)
            
        }
        .alert("Password reset", isPresented: $passwordIsReset, actions: {
            Button("OK") {
                dismiss()
            }
        }, message: {
            Text("An email has been sent to reset your password.")
        })
        .alert("Error", isPresented: $viewModel.isError, actions: {
            Button("OK") {
                
            }
        }, message: {
            Text(viewModel.errorMessage)
        })
        .onAppear {
            viewModel.email = ""
            viewModel.password = ""
        }
    }
}

#Preview {
    ResetPasswordView()
        .environmentObject(AuthViewModel())
}
