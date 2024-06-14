//
//  FeedView.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import SwiftUI

struct FeedView: View {
    
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.feeds) { feed in
                        NavigationLink(destination: FeedDetailsView(feed: feed)) {
                            FeedCell(feed: feed)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .refreshable {
                Task { try await viewModel.fetchFeeds() }
            }
            .navigationTitle("ConnectMe")
            .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.colorA)
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        FeedView()
    }
}
