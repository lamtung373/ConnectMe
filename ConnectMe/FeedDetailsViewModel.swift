//
//  FeedDetailsViewModel.swift
//  ConnectMe
//
//  Created by Tisp on 21/5/24.
//

import Foundation

@MainActor
class FeedDetailsViewModel: ObservableObject {
    @Published var replies = [FeedReply]()
    
    private let feed: Feed
    
    init(feed: Feed) {
        self.feed = feed
        Task { try await fetchFeedReplies() }
    }
    
    private func fetchFeedReplies() async throws {
        self.replies = try await FeedReplyService.fetchFeedReplies(forFeed: feed)
         try await fetchUserDataForReplies()
    }
    
    private func fetchUserDataForReplies() async throws {
        
        for i in 0 ..< replies.count {
            let reply = replies[i]
            
            async let user = try await UserService.fetchUser(withUid: reply.feedReplyOwnerUid)
            self.replies[i].replyUser = try await user
        }
    }
}
