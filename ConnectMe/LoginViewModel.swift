//
//  LoginViewModel.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    //Biến chức năng đăng nhập
    @Published var email = ""
    @Published var password = ""
    
    @MainActor
    func login() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}
