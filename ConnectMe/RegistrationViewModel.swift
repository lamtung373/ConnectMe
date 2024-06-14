//
//  RegistrationViewModel.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    
    //Biến chức năng đăng ký
    @Published var fullname = ""
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    
    @MainActor
    func createUser() async throws {
        try await AuthService.shared.createUser(
            withEmail: email,
            password: password,
            fullname: fullname,
            username: username
        )
    }
}
