//
//  ForgotPasswordViewModel.swift
//  ConnectMe
//
//  Created by Tisp on 21/5/24.
//

import Foundation

class ForgotPasswordViewModel: ObservableObject {
    
    // Biến theo dõi địa chỉ email của người dùng
    @Published var email = ""
    
    @MainActor
    func sendPasswordReset() async throws {
        try await AuthService.shared.forgotPassword(withEmail: email)
    }
}
