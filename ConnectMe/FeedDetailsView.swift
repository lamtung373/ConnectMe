//
//  FeedDetailsView.swift
//  ConnectMe
//
//  Created by Tisp on 19/5/24.
//

import SwiftUI
import Kingfisher

struct FeedDetailsView: View {
    
    let feed: Feed
    
    @StateObject var viewModel: FeedDetailsViewModel
    
    init(feed: Feed) {
        self.feed = feed
        self._viewModel = StateObject(wrappedValue: FeedDetailsViewModel(feed: feed))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HStack {
                    CircularProfilelmageView(user: feed.user, size: .small)
                    
                    Text(feed.user?.username ?? "")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(feed.timestamp.timestampString())
                        .font(.caption)
                        .foregroundStyle(Color(.systemGray2))
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.colorA)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(feed.caption)
                        .font(.subheadline)
                    
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
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .padding(.vertical)
                
                LazyVStack {
                    ForEach(viewModel.replies) { reply in
                        FeedReplyCell(reply: reply)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Feed")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    FeedDetailsView()
//}

struct FeedDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedDetailsView(feed: dev.feed)
    }
}
