//
//  EditProfileViewModel.swift
//  ConnectMe
//
//  Created by Tisp on 2/4/24.
//

import SwiftUI
import PhotosUI

class EditProfileViewModel: ObservableObject {
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    @Published var profileImage: Image?
    @Published var bio: String = ""
    @Published var link: String = ""
    @Published var isPrivateProfile: Bool = false
    
    private var uiImage: UIImage?
    
    init() {
        Task { await loadUserInfo() }
    }
    
    func updateUserData() async throws {
        try await updateProfileImage()
        try await updateProfileInfo()
    }
    
    @MainActor
    private func loadImage() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    @MainActor
    private func loadUserInfo() async {
        guard let currentUser = UserService.shared.currentUser else { return }
        self.bio = currentUser.bio ?? ""
        self.link = currentUser.link ?? ""
        self.isPrivateProfile = currentUser.isPrivate
    }
    
    private func updateProfileImage() async throws {
        guard let image = self.uiImage else { return }
        guard let imageUrl = try? await ImageUploader.uploadImage(image) else { return }
        try await UserService.shared.updateUserProfileImage(withImageUrl: imageUrl)
    }
    
    private func updateProfileInfo() async throws {
        try await UserService.shared.updateUserProfile(bio: bio, link: link, isPrivate: isPrivateProfile)
    }
}
