//
//  UserCell.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import SwiftUI

struct UserCell: View {
    
    let user: User
    
    @State private var isFollowing: Bool = false
    
    var body: some View {
        HStack {
            CircularProfilelmageView(user: user, size: .small)
            
            VStack(alignment: .leading, spacing: 2 ) {
                Text(user.username)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text(user.fullname)
                    .foregroundColor(.black)
            }
            .font(.footnote)
            
            Spacer()
            
            Text(isFollowing ? "Unfollow" : "Follow")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 100, height: 32)
                .background(isFollowing ? Color.white : Color.colorA)
                .cornerRadius(10)
                .foregroundColor(isFollowing ? Color.colorA : Color.white)
                .overlay {
                    if isFollowing {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    }
                }
        }
        .padding(.horizontal)
        .onAppear {
            checkFollowingStatus()
        }
    }
    
    private func checkFollowingStatus() {
        if let currentUser = UserService.shared.currentUser {
            isFollowing = currentUser.following.contains(user.id)
        }
    }
}

//#Preview {
//    UserCell()
//}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(user: dev.user)
    }
}
