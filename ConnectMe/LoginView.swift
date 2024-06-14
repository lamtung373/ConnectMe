//
//  LoginView.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    @State private var isLoggingIn = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                
                VStack {
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
                        Text("Password")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        Spacer()
                    }
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .modifier(ConnectMeTextFieldModifier())
                }
                
                NavigationLink {
                    ForgotPasswordView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Forgot password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                        .padding(.trailing, 28)
                        .foregroundColor(.colorA)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Button {
                    Task {
                        isLoggingIn = true
                        defer { isLoggingIn = false }
                        
                        try await viewModel.login()
                    }
                } label: {
                    if isLoggingIn {
                        ProgressView()
                            .frame(width: 352, height: 44)
                            .background(.colorA)
                            .cornerRadius(10)
                    } else {
                        Text("Login")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 352, height: 44)
                            .background(.colorA)
                            .cornerRadius(10)
                    }
                }
                .disabled(isLoggingIn)
                
                Spacer()
                
                Divider()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                            .foregroundColor(.black)
                        
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .foregroundColor(.colorA)
                    }
                    .font(.footnote)
                }
                .padding(.vertical, 16)
            }
        }
    }
}

#Preview {
    LoginView()
}
