//
//  ProfileView.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import SwiftUI

struct ProfileView: View {
    
    let user: User
    
    @State private var isFollowing: Bool = false
    @State private var refreshTrigger = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            //Bio and stats
            VStack(spacing: 20) {
                ProfileHeaderView(user: user)
                
                Button {
                    Task {
                        await toggleFollow()
                    }
                } label: {
                    Text(isFollowing ? "Unfollow" : "Follow")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(isFollowing ? Color.colorA : Color.white)
                        .frame(width: 352, height: 32)
                        .background(isFollowing ? Color.white : Color.colorA)
                        .cornerRadius(10)
                        .overlay {
                            if isFollowing {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                        }
                }
                
                //User content list view
                UserContentListView(user: user, refreshTrigger: $refreshTrigger)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
        .onAppear {
            checkFollowingStatus()
        }
        .refreshable {
            refreshTrigger.toggle() // Trigger refresh in UserContentListView
        }
    }
    
    private func checkFollowingStatus() {
        if let currentUser = UserService.shared.currentUser {
            isFollowing = currentUser.following.contains(user.id)
        }
    }
    
    private func toggleFollow() async {
        if isFollowing {
            try? await UserService.shared.unfollowUser(userId: user.id)
            isFollowing = false
        } else {
            try? await UserService.shared.followUser(userId: user.id)
            isFollowing = true
        }
        refreshTrigger.toggle()
    }
}

//#Preview {
//    ProfileView()
//}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}
