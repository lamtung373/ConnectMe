//
//  ProfileViewModel.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import Foundation
import Combine
import PhotosUI
import SwiftUI

class CurrentUserProfileViewModel: ObservableObject {
    
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubcribers()
    }
    
    private func setupSubcribers() {
        UserService.shared.$currentUser
            .receive(on: DispatchQueue.main)
            .sink {[weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)
    }
    
    func refreshData() async {
        do {
            try await UserService.shared.fetchCurrentUser()
        } catch {
            print("Failed to refresh data: \(error)")
        }
    }
}
