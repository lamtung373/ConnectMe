//
//  FeedReplyView.swift
//  ConnectMe
//
//  Created by Tisp on 19/5/24.
//

import SwiftUI
import Kingfisher

struct FeedReplyView: View {
    
    let feed: Feed
    
    @State private var replyText = ""
    @State private var feedViewHeight: CGFloat = 24
    @State private var isPosting = false
    
    @StateObject var viewModel = FeedReplyViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    private var currentUser: User? {
        return UserService.shared.currentUser
    }
    
    func setFeedViewHeight() {
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
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        VStack {
                            CircularProfilelmageView(user: feed.user, size: .small)
                            
                            Rectangle()
                                .frame(width: 2, height: feedViewHeight)
                                .foregroundColor(Color(.systemGray4))
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(feed.user?.username ?? "")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            
                            Text(feed.caption)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.black)
                            
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
                        
                        Spacer()
                    }
                    
                    HStack(alignment: . top) {
                        CircularProfilelmageView(user: currentUser, size: .small)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentUser?.username ?? "")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            
                            TextField("Add your reply...", text: $replyText, axis: .vertical)
                                .multilineTextAlignment(.leading)
                        }
                        .font(.footnote)
                    }
                }
                .padding()
                
                Spacer()
            }
            .onAppear { setFeedViewHeight() }
            .navigationTitle("Reply")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.colorA)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isPosting {
                        ProgressView()
                    } else {
                        Button("Post") {
                            isPosting = true
                            Task {
                                try await viewModel.uploadFeedReply(replyText: replyText, feed: feed)
                                dismiss()
                                isPosting = false
                            }
                        }
                        .opacity(replyText.isEmpty ? 0.5 : 1.0)
                        .disabled(replyText.isEmpty)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.colorA)
                    }
                }
            }
        }
    }
}

//#Preview {
//    FeedReplyView()
//}

struct FeedReplyView_Previews: PreviewProvider {
    static var previews: some View {
        FeedReplyView(feed: dev.feed)
    }
}
