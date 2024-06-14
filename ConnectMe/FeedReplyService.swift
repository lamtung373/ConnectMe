//
//  FeedReplyService.swift
//  ConnectMe
//
//  Created by Tisp on 19/5/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct FeedReplyService {
    
    static func uploadFeedReply(_ reply: FeedReply, toFeed feed: Feed) async throws {
        guard let replyData = try? Firestore.Encoder().encode(reply) else { return }
        
        async let _ = try await FirestoreConstants.RepliesCollection.document().setData(replyData)
        async let _ = try await FirestoreConstants.FeedsCollection.document(feed.id).updateData([
            "replyCount": feed.replyCount + 1
        ])
    }
    
    static func fetchFeedReplies(forFeed feed: Feed) async throws -> [FeedReply] {
        let snapshot = try await FirestoreConstants
            .RepliesCollection
            .whereField("feedId", isEqualTo: feed.id)
            .getDocuments()
        
        let replies = snapshot.documents.compactMap({ try? $0.data(as: FeedReply.self) })
        
        return replies.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
    
    static func fetchFeedReplies(forUser user: User) async throws -> [FeedReply] {
        let snapshot = try await FirestoreConstants
            .RepliesCollection
            .whereField("feedOwnerUid", isEqualTo: user.id)
            .getDocuments()
        
        let replies = snapshot.documents.compactMap({ try? $0.data(as: FeedReply.self) })
        
        return replies.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
}
