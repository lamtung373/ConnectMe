//
//  Constants.swift
//  ConnectMe
//
//  Created by Tisp on 19/5/24.
//

import Firebase
struct FirestoreConstants {
    private static let Root = Firestore.firestore()
    
    static let UserCollection = Root.collection("users")
    
    static let FeedsCollection = Root.collection("feeds")
    
    static let FollowersCollection = Root.collection("followers")
    
    static let FollowingCollection = Root.collection("following")
    
    static let RepliesCollection = Root.collection("replies")
    
    static let ActivityCollection = Root.collection("activity")
}
