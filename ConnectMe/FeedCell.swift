//
//  FeedCell.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import SwiftUI
import Kingfisher

struct FeedCell: View {
    
    @State private var showMenu = false
    @State private var showDeleteAlert = false
    
    let feed: Feed
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                CircularProfilelmageView(user: feed.user, size: .small)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(feed.user?.username ?? "")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text(feed.timestamp.timestampString())
                            .font(.caption)
                            .foregroundColor(Color(.systemGray2))
                        
                        if feed.user?.id == UserService.shared.currentUser?.id {
                            Button {
                                showMenu = true
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(Color(.colorA))
                            }
                            .actionSheet(isPresented: $showMenu) {
                                ActionSheet(title: Text("Options"), buttons: [
                                    .destructive(Text("Delete"), action: {
                                        showDeleteAlert = true
                                    }),
                                    .cancel()
                                ])
                            }
                            .alert(isPresented: $showDeleteAlert) {
                                Alert(
                                    title: Text("Delete Feed"),
                                    message: Text("Are you sure you want to delete this feed?"),
                                    primaryButton: .destructive(Text("Delete"), action: {
                                        Task {
                                            try await FeedService.deleteFeed(feed)
                                        }
                                    }),
                                    secondaryButton: .cancel()
                                )
                            }
                        }
                    }
                    
                    Text(feed.caption)
                        .font(.footnote)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if !feed.imageUrl.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(feed.imageUrl, id: \.self) { imageUrl in
                                    KFImage(URL(string: imageUrl))
                                        .placeholder {
                                            ProgressView()
                                                .frame(width: 200, height: 300)
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(10)
                                        }
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 300)
                                        .cornerRadius(10)
                                        .clipped()
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                    
                    ContentActionButtonsView(feed: feed)
                        .padding(.vertical, 8)
                }
            }
            
            Divider()
        }
        .padding()
    }
}

//#Preview {
//    FeedCell()
//}

struct FeedCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedCell(feed: dev.feed)
    }
}
