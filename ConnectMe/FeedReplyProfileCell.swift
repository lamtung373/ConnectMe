//
//  FeedReplyProfileCell.swift
//  ConnectMe
//
//  Created by Tisp on 21/5/24.
//

import SwiftUI
import Kingfisher

struct FeedReplyProfileCell: View {
    
    let reply: FeedReply
    
    @State private var feedViewHeight: CGFloat = 24
    
    func setFeedViewHeight() {
        if let feed = reply.feed {
            let imageDimension: CGFloat = ProfileImageSize.small.dimension
            let padding: CGFloat = 16
            let width = UIScreen.main.bounds.width - imageDimension - padding
            let font = UIFont.systemFont(ofSize: 12)
            
            let captionSize = feed.caption.heightWithConstraineWidth(width, font: font)
            
            if !feed.imageUrl.isEmpty {
                feedViewHeight = captionSize + imageDimension + 150
            } else {
                feedViewHeight = captionSize + imageDimension
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let feed = reply.feed {
                HStack(alignment: .top) {
                    VStack {
                        CircularProfilelmageView(user: feed.user, size: .small)
                        
                        Rectangle()
                            .frame(width: 2, height: feedViewHeight)
                            .foregroundStyle(Color(.systemGray4))
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(feed.user?.username ?? "")
                                .fontWeight(.semibold)
                            
                            Text(feed.caption)
                            
                            if !feed.imageUrl.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(feed.imageUrl, id: \.self) { imageUrl in
                                            KFImage(URL(string: imageUrl))
                                                .placeholder {
                                                    ProgressView()
                                                        .frame(width: 100, height: 150)
                                                        .background(Color.gray.opacity(0.2))
                                                        .cornerRadius(10)
                                                }
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 150)
                                                .cornerRadius(10)
                                                .clipped()
                                        }
                                    }
                                    .padding(.top, 10)
                                }
                            }
                        }
                        .font(.footnote)
                        
                        ContentActionButtonsView(feed: feed)
                    }
                    
                    Spacer()
                }
            }
            
            HStack(alignment: .top) {
                CircularProfilelmageView(user: reply.replyUser, size: .small)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(reply.replyUser?.username ?? "")
                        .fontWeight(.semibold)
                        
                    Text(reply.replyText)
                }
                .font(.footnote)
            }
            
            Divider()
                .padding(.bottom, 8)
        }
        .onAppear { setFeedViewHeight() }
        .padding(.horizontal)
    }
}

//#Preview {
//    FeedReplyProfileCell()
//}

struct FeedReplyProfileCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedReplyProfileCell(reply: DeveloperPreview.shared.reply)
    }
}
