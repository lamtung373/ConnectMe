//
//  ProfileHeaderView.swift
//  ConnectMe
//
//  Created by Tisp on 31/3/24.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    var user: User?
    
    init(user: User?) {
        self.user = user
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 12) {
                //Full name and username
                VStack(alignment: .leading, spacing: 4) {
                    Text(user?.fullname ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(user?.username ?? "")
                        .font(.subheadline)
                }
                
                if let bio = user?.bio {
                    if !bio.isEmpty {
                        Text(bio)
                            .font(.footnote)
                    }
                }
                
                if let link = user?.link {
                    if !link.isEmpty {
                        HStack(spacing: 2) {
                            Image(systemName: "link")
                            Text(link)
                                .font(.footnote)
                                .underline()
                                .onTapGesture {
                                    if let url = URL(string: link) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                        }
                    }
                }
                
                HStack(spacing: 10) {
                    Text("\(user?.followers.count ?? 0) followers")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("\(user?.following.count ?? 0) following")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            CircularProfilelmageView(user: user, size: .large)
        }
    }
}

//#Preview {
//    ProfileHeaderView()
//}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(user: dev.user)
    }
}
