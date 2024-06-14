//
//  UserContentListViewModel.swift
//  ConnectMe
//
//  Created by Tisp on 4/4/24.
//

import Foundation

@MainActor
class UserContentListViewModel: ObservableObject {
    @Published var feeds = [Feed]()
    @Published var replies = [FeedReply]()
    
    let user: User
    
    init(user: User) {
        self.user = user
        Task { try await fetchUserFeeds() }
        Task { try await fetchUserReplies() }
    }
    
    func fetchUserFeeds() async throws {
        var feeds = try await FeedService.fetchUserFeeds(uid: user.id)
        
        for i in 0 ..< feeds.count {
            feeds[i].user = self.user
        }
        
        self.feeds = feeds
    }
    
    func fetchUserReplies() async throws {
        self.replies = try await FeedService.fetchFeedReplies(forUser: user)
        try await fetchReplyFeedData()
    }
    
    func fetchReplyFeedData() async throws {
        for i in 0 ..< replies.count {
            let reply = replies[i]
            
            var feed = try await FeedService.fetchFeed(feedId: reply.feedId)
            feed.user = try await UserService.fetchUser(withUid: feed.ownerUid)
            
            replies[i].feed = feed
        }
    }
    
    func refresh() async {
            do {
                try await fetchUserFeeds()
                try await fetchUserReplies()
            } catch {
                print("Failed to refresh user content: \(error)")
            }
        }
}
