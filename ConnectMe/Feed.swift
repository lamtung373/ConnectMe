//
//  Feed.swift
//  ConnectMe
//
//  Created by Tisp on 4/4/24.
//

import Firebase
import FirebaseFirestoreSwift

struct Feed: Identifiable, Hashable, Codable {
    @DocumentID var feedId: String?
    let ownerUid: String
    let caption: String
    let imageUrl: [String]
    let timestamp: Timestamp
    var likes: Int
    var replyCount: Int
    
    var didLike: Bool? = false
    
    // Tạo rundom uid Feed
    var id: String {
        return feedId ?? NSUUID().uuidString
    }
    
    var user: User?
}
