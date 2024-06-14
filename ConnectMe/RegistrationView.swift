//
//  RegistrationView.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import SwiftUI

struct RegistrationView: View {
    
    @StateObject var viewModel = RegistrationViewModel()
    
    //Biến môi trường
    @Environment(\.dismiss) var dismiss
    
    @State private var isRegistering = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
            
            VStack {
                HStack {
                    Text("Full name")
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                    
                    Spacer()
                }
                
                TextField("Enter your full name", text: $viewModel.fullname)
                    .modifier(ConnectMeTextFieldModifier())
                    .padding(.bottom, 10)
                
                HStack {
                    Text("Email Adress")
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                    
                    Spacer()
                }
                
                TextField("Enter your email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(ConnectMeTextFieldModifier())
                    .padding(.bottom, 10)
                
                HStack {
                    Text("Username")
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                    
                    Spacer()
                }
                
                TextField("Enter your username", text: $viewModel.username)
                    .autocapitalization(.none)
                    .modifier(ConnectMeTextFieldModifier())
                    .padding(.bottom, 10)
                
                HStack {
                    Text("Password")
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                    
                    Spacer()
                }
                
                SecureField("Enter your password", text: $viewModel.password)
                    .modifier(ConnectMeTextFieldModifier())
            }
            
            Button {
                Task {
                    isRegistering = true
                    defer { isRegistering = false }
                    
                    try await viewModel.createUser()
                }
            } label: {
                if isRegistering {
                    ProgressView()
                        .frame(width: 352, height: 44)
                        .background(.colorA)
                        .cornerRadius(10)
                } else {
                    Text("Sign Up")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 352, height: 44)
                        .background(.colorA)
                        .cornerRadius(10)
                }
            }
            .disabled(isRegistering)
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
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
    RegistrationView()
}
