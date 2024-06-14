//
//  ForgotPasswordView.swift
//  ConnectMe
//
//  Created by Tisp on 21/5/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @StateObject var viewModel = ForgotPasswordViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isResettingPassword = false // Biến trạng thái để kiểm soát việc hiển thị ProgressView()
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            VStack {
                HStack {
                    Text("Email")
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                    
                    Spacer()
                }
                
                TextField("Enter your email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(ConnectMeTextFieldModifier())
                    .padding(.bottom, 10)
            }
            
            Button {
                Task {
                    isResettingPassword = true
                    defer { isResettingPassword = false }
                    
                    try await viewModel.sendPasswordReset()
                }
            } label: {
                if isResettingPassword {
                    ProgressView()
                        .frame(width: 352, height: 44)
                        .background(.colorA)
                        .cornerRadius(10)
                } else {
                    Text("Reset Password")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 352, height: 44)
                        .background(.colorA)
                        .cornerRadius(10)
                }
            }
            .disabled(isResettingPassword)
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Password reset successful?")
                        .foregroundColor(.black)
                    
                    Text("Login")
                        .fontWeight(.semibold)
                        .foregroundColor(.colorA)
                }
                .font(.footnote)
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    ForgotPasswordView()
}
