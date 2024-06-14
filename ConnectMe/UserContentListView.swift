//
//  UserContentListView.swift
//  ConnectMe
//
//  Created by Tisp on 2/4/24.
//

import SwiftUI

struct UserContentListView: View {
    
    @StateObject var viewModel: UserContentListViewModel
    
    @Binding var refreshTrigger: Bool
    
    @State private var selectedFilter: ProfileFeedFilter = .feeds
    
    @Namespace var animation
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(ProfileFeedFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 16
    }
    
    init(user: User, refreshTrigger: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: UserContentListViewModel(user: user))
        self._refreshTrigger = refreshTrigger
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    ForEach(ProfileFeedFilter.allCases) { filter in
                        VStack {
                            Text(filter.title)
                                .font(.subheadline)
                                .fontWeight(selectedFilter == filter ? .bold : .regular)
                                .foregroundColor(.colorA)
                            
                            
                            if selectedFilter == filter {
                                Rectangle()
                                    .foregroundColor(.colorA)
                                    .frame(width: filterBarWidth, height: 1.5)
                                    .matchedGeometryEffect(id: "item", in: animation)
                            } else {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: filterBarWidth, height: 2)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedFilter = filter
                            }
                        }
                    }
                }
                
                LazyVStack {
                    switch selectedFilter {
                    case .feeds:
                        ForEach(viewModel.feeds) { feed in
                            NavigationLink(destination: FeedDetailsView(feed: feed)) {
                                FeedCell(feed: feed)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .transition(.move(edge: .leading))
                        }
                    case .replies:
                        ForEach(viewModel.replies) { reply in
                            if let feed = reply.feed {
                                NavigationLink(destination: FeedDetailsView(feed: feed)) {
                                    FeedReplyProfileCell(reply: reply)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .transition(.move(edge: .trailing))
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 8)
            .onChange(of: refreshTrigger) { _ in
                Task {
                    await viewModel.refresh()
                }
            }
        }
    }
}

//#Preview {
//    UserContentListView()
//}

struct UserContentListView_Previews: PreviewProvider {
    
    @State static var refreshTrigger = false
    
    static var previews: some View {
        UserContentListView(user: dev.user, refreshTrigger: $refreshTrigger)
    }
}
