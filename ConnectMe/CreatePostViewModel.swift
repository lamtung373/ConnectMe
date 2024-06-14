//
//  CreatePostViewModel.swift
//  ConnectMe
//
//  Created by Tisp on 4/4/24.
//

import Firebase
import SwiftUI

class CreatePostViewModel: ObservableObject {
    
    @Published var selectedImages: [UIImage] = []
    @Published var images: [Image] = []
    
    func uploadFeed(caption: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Upload images if available
        var imageUrls: [String] = []
        for selectedImage in selectedImages {
            if let imageUrl = try await ImageUploader.uploadImage(selectedImage) {
                imageUrls.append(imageUrl)
            }
        }
        
        let feed = Feed(ownerUid: uid, caption: caption, imageUrl: imageUrls, timestamp: Timestamp(), likes: 0, replyCount: 0)
        try await FeedService.uploadFeed(feed)
    }
}
