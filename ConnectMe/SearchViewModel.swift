//
//  SearchViewModel.swift
//  ConnectMe
//
//  Created by Tisp on 30/3/24.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var filteredUsers = [User]()
    
    init() {
        Task { try await fetchUsers() }
    }
    
    @MainActor
    private func fetchUsers() async throws {
        self.users = try await UserService.fetchUser()
        self.filteredUsers = users
    }
    
    func filterUsers(for searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { user in
                user.fullname.lowercased().contains(searchText.lowercased()) ||
                user.username.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
