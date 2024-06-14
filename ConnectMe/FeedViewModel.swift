//
//  FeedViewModel.swift
//  ConnectMe
//
//  Created by Tisp on 4/4/24.
//

import Foundation

@MainActor
class FeedViewModel: ObservableObject {
    @Published var feeds = [Feed]()
    
    init() {
        Task { try await fetchFeeds() }
    }
    
    func fetchFeeds() async throws {
        self.feeds = try await FeedService.fetchFeeds()
        try await fetchUserDataForFeeds()
    }
    
    private func fetchUserDataForFeeds() async throws {
        for i in 0 ..< feeds.count {
            let feed = feeds[i]
            
            let ownerUid = feed.ownerUid
            
            let feedUser = try await UserService.fetchUser(withUid: ownerUid)
            
            feeds[i].user = feedUser
        }
    }
}
