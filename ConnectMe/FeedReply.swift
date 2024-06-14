//
//  FeedReply.swift
//  ConnectMe
//
//  Created by Tisp on 19/5/24.
//

import Firebase
import FirebaseFirestoreSwift

struct FeedReply: Identifiable, Codable {
    @DocumentID var replyId: String?
    let feedId: String
    let replyText: String
    let feedReplyOwnerUid: String
    let feedOwnerUid: String
    let timestamp: Timestamp
    
    var feed: Feed?
    var replyUser: User?
    
    var id: String {
        return replyId ?? NSUUID().uuidString
    }
}
