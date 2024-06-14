//
//  UserService.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import Firebase
import FirebaseFirestoreSwift

class UserService {
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    init() {
        Task { try await fetchCurrentUser() }
    }
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }
    
    static func fetchUser() async throws -> [User] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        return users.filter({ $0.id != currentUid })
    }
    
    static func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    func reset() {
        self.currentUser = nil
    }
    
    @MainActor
    func updateUserProfileImage(withImageUrl imageUrl: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("users").document(currentUid).updateData([
            "profileImageUrl": imageUrl
        ])
        self.currentUser?.profileImageUrl = imageUrl
    }
    
    @MainActor
        func updateUserProfile(bio: String, link: String, isPrivate: Bool) async throws {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            try await Firestore.firestore().collection("users").document(uid).updateData([
                "bio": bio,
                "link": link,
                "isPrivate": isPrivate
            ])
            currentUser?.bio = bio
            currentUser?.link = link
            currentUser?.isPrivate = isPrivate
        }
    
        @MainActor
        func followUser(userId: String) async throws {
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            try await Firestore.firestore().collection("users").document(currentUid).updateData([
                "following": FieldValue.arrayUnion([userId])
            ])
            
            try await Firestore.firestore().collection("users").document(userId).updateData([
                "followers": FieldValue.arrayUnion([currentUid])
            ])
            
            self.currentUser?.following.append(userId)
            
            if let currentUsername = currentUser?.username {
                let description = "\(currentUsername) started following you."
                ActivityService.addActivity(
                    userId: currentUid,
                    type: "follow",
                    details: ["description": description],
                    activityFor: userId
                )
            }
        }

        @MainActor
        func unfollowUser(userId: String) async throws {
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            try await Firestore.firestore().collection("users").document(currentUid).updateData([
                "following": FieldValue.arrayRemove([userId])
            ])
            
            try await Firestore.firestore().collection("users").document(userId).updateData([
                "followers": FieldValue.arrayRemove([currentUid])
            ])
            
            self.currentUser?.following.removeAll { $0 == userId }
        }
}
