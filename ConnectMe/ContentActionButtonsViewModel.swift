//
//  ContentActionButtonsViewModel.swift
//  ConnectMe
//
//  Created by Tisp on 19/5/24.
//

import Foundation

@MainActor
class ContentActionButtonsViewModel: ObservableObject {
    @Published var feed: Feed
    
    // Hàm khởi tạo
    init(feed: Feed) {
        self.feed = feed
        // Kiểm tra user
        Task { try await checkIfUserLikedFeed() }
    }
    
    func likeFeed() async throws {
        try await FeedService.likeFeed(feed)
        self.feed.didLike = true
        self.feed.likes += 1
    }
    
    func unlikeFeed() async throws {
        try await FeedService.unlikeFeed(feed)
        self.feed.didLike = false
        self.feed.likes -= 1
    }
    
    func checkIfUserLikedFeed() async throws {
        let didLike = try await FeedService.checkIfUserLikedFeed(feed)
        
        if didLike {
            self.feed.didLike = true
        }
    }
}
