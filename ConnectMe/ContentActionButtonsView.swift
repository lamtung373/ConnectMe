//
//  ContentActionButtonsView.swift
//  ConnectMe
//
//  Created by Tisp on 19/5/24.
//

import SwiftUI

struct ContentActionButtonsView: View {
    @ObservedObject var viewModel: ContentActionButtonsViewModel
    
    @State private var showReplySheet = false
    
    init(feed: Feed) {
        self.viewModel = ContentActionButtonsViewModel(feed: feed)
    }
    
    private var didLike: Bool {
        return viewModel.feed.didLike ?? false
    }
    
    private var feed: Feed {
        return viewModel.feed
    }
    
    func handleLikeTapped() {
        Task {
            if didLike {
                try await viewModel.unlikeFeed()
            } else {
                try await viewModel.likeFeed()
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 15) {
                HStack(spacing: 5) {
                    Button {
                        handleLikeTapped()
                    } label: {
                        Image(systemName: didLike ? "heart.fill" : "heart")
                            .foregroundColor(didLike ? .red : .colorA)
                    }
                    
                    if feed.likes > 0 {
                        Text("\(feed.likes) likes")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                    }
                }
                
                // Xử lý khi tương tác với nút reply
                HStack(spacing: 5) {
                    Button {
                        showReplySheet.toggle()
                    } label: {
                        Image(systemName: "bubble.right")
                            .foregroundColor(.colorA)
                    }
                    
                    if feed.replyCount > 0 {
                        Text("\(feed.replyCount) replies")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
//                Button {
//                    
//                } label: {
//                    Image(systemName: "arrow.rectanglepath")
//                        .foregroundColor(.colorA)
//                }
//                
//                Button {
//                    
//                } label: {
//                    Image(systemName: "paperplane")
//                        .foregroundColor(.colorA)
//                }
            }
            
//            HStack(spacing: 4) {
//                if feed.replyCount > 0 {
//                    Text("\(feed.replyCount) repies")
//                }
//                
//                if feed.replyCount > 0 && feed.likes > 0{
//                    Text("-")
//                }
//                
//                if feed.likes > 0 {
//                    Text("\(feed.likes) likes")
//                }
//            }
//            .font(.caption)
//            .foregroundColor(.gray)
//            .padding(.vertical, 4)
        }
        .sheet(isPresented: $showReplySheet) {
            FeedReplyView(feed: feed)
        }
    }
}

//#Preview {
//    ContentActionButtonsView()
//}

struct ContentActionButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentActionButtonsView(feed: dev.feed)
    }
}
