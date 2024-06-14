//
//  FeedReplyViewModel.swift
//  ConnectMe
//
//  Created by Tisp on 19/5/24.
//

import Foundation
import Firebase

class FeedReplyViewModel: ObservableObject {
    
    func uploadFeedReply(replyText: String, feed: Feed) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reply = FeedReply(
            feedId: feed.id,
            replyText: replyText,
            feedReplyOwnerUid: uid,
            feedOwnerUid: feed.ownerUid,
            timestamp: Timestamp()
        )
        try await FeedReplyService.uploadFeedReply(reply, toFeed: feed)
        
        // Add activity
        if let username = feed.user?.username {
            let activityDetails: [String: Any] = [
                "description": "\(username) replied to your feed: '\(feed.caption)'",
                "feedId": feed.id,
                "replyText": replyText
            ]
            ActivityService.addActivity(
                userId: uid,
                type: "reply",
                details: activityDetails,
                activityFor: feed.ownerUid
            )
        }
    }
}
