//
//  FeedService.swift
//  ConnectMe
//
//  Created by Tisp on 4/4/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct FeedService {
    static func uploadFeed(_ feed: Feed) async throws {
        guard let feedData = try? Firestore.Encoder().encode(feed) else { return }
        try await Firestore.firestore().collection("feeds").addDocument(data: feedData)
    }
    
    static func fetchFeeds() async throws -> [Feed] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        
        let userSnapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        guard let user = try? userSnapshot.data(as: User.self) else { return [] }
        
        let following = user.following
        
        var feeds: [Feed] = []
        
        //Load các feed của currentUser
        let currentUserFeedsSnapshot = try await Firestore.firestore().collection("feeds")
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments()
        let currentUserFeeds = currentUserFeedsSnapshot.documents.compactMap { try? $0.data(as: Feed.self) }
        
        feeds.append(contentsOf: currentUserFeeds)
        
        //Load các feed của currentUser đang theo dõi
        if !following.isEmpty {
            let followingFeedsSnapshot = try await Firestore.firestore().collection("feeds")
                .whereField("ownerUid", in: following)
                .getDocuments()
            let followingFeeds = followingFeedsSnapshot.documents.compactMap { try? $0.data(as: Feed.self) }
            
            feeds.append(contentsOf: followingFeeds)
        }
        
        return feeds.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
    
    static func fetchUserFeeds(uid: String) async throws -> [Feed] {
        let snapshot = try await Firestore
            .firestore()
            .collection("feeds")
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments()
        
        let feeds = snapshot.documents.compactMap({ try? $0.data(as: Feed.self) })
        return feeds.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
    
    static func fetchFeedReplies(forUser user: User) async throws -> [FeedReply] {
        let snapshot = try await FirestoreConstants
            .RepliesCollection
            .whereField("feedReplyOwnerUid", isEqualTo: user.id)
            .getDocuments()
        
        var replies = snapshot.documents.compactMap({ try? $0.data(as: FeedReply.self) })
        
        for i in 0 ..< replies.count {
            replies[i].replyUser = user
        }
        
        return replies.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
    
    static func fetchFeed(feedId: String) async throws -> Feed {
        let snapshot = try await FirestoreConstants
            .FeedsCollection
            .document(feedId)
            .getDocument()
        
        return try snapshot.data(as: Feed.self)
    }
    
    static func deleteFeed(_ feed: Feed) async throws {
        // Xóa feed khỏi Firestore
        try await FirestoreConstants.FeedsCollection.document(feed.id).delete()
        
        // Xóa các likes liên quan đến feed này
        let likesSnapshot = try await FirestoreConstants.FeedsCollection.document(feed.id).collection("feed-likes").getDocuments()
        for document in likesSnapshot.documents {
            try await document.reference.delete()
        }
        
        // Xóa các replies liên quan đến feed này
        let repliesSnapshot = try await FirestoreConstants.RepliesCollection
            .whereField("feedId", isEqualTo: feed.id)
            .getDocuments()
        for document in repliesSnapshot.documents {
            try await document.reference.delete()
        }
    }
}

extension FeedService {
    static func likeFeed(_ feed: Feed) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let feedRef = FirestoreConstants.FeedsCollection.document(feed.id)
        
        async let _ = try await feedRef.collection("feed-likes").document(uid).setData([:])
        async let _ = try await feedRef.updateData(["likes": feed.likes + 1])
        async let _ = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(feed.id).setData([:])
        
        // Add activity
        if let username = feed.user?.username {
            let description = "\(username) liked a feed."
            ActivityService.addActivity(
                userId: uid,
                type: "like",
                details: ["description": description],
                activityFor: feed.ownerUid
            )
        }
    }
    
    static func unlikeFeed(_ feed: Feed) async throws {
        guard feed.likes > 0 else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let feedRef = FirestoreConstants.FeedsCollection.document(feed.id)
        
        async let _ = feedRef.collection("feed-likes").document(uid).delete()
        async let _ = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(feed.id).delete()
        async let _ = try await feedRef.updateData(["likes": feed.likes - 1])
    }
    
    static func checkIfUserLikedFeed(_ feed: Feed) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        
        let snapshot = try await FirestoreConstants
            .UserCollection
            .document(uid)
            .collection("user-likes")
            .document(feed.id)
            .getDocument()
        return snapshot.exists
    }
}
