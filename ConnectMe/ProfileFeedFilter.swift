//
//  ProfileFeedFilter.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import Foundation

enum ProfileFeedFilter: Int, CaseIterable, Identifiable {
    case feeds
    case replies
    
    var title: String {
        switch self {
        case .feeds: return "Feeds"
        case .replies: return "Replies"
        }
    }
    
    var id: Int {
        return self.rawValue
    }
}
