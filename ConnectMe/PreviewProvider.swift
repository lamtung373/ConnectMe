//
//  PreviewProvider.swift
//  ConnectMe
//
//  Created by Tisp on 30/3/24.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let user = User(id: NSUUID().uuidString, fullname: "Tisp", email: "tisp@gmail.com", username: "tisp373")
    
    lazy var feed = Feed(
        ownerUid: "12345",
        caption: "This is a test sdf adf á dfaosdf á d àoisf àoidy ápodfyaos foaisudf yoiasfyasu foiasu fyoiasdyf iuasdy foiuasdyofiausydf iayfioaus dỳoisdfiuahgsdifisf",
        imageUrl: ["dsfsdfs", "adasdsad"],
        timestamp: Timestamp(),
        likes: 37,
        replyCount: 5,
        user: user
    )
    
    lazy var reply = FeedReply(
        feedId: "12345",
        replyText: "This is replyá dfsf ádf àoi sadfoiasdy fioasudfy óidufy áoiudfbfaiuwegf oáiuf baoisufoaisdfu gáoiudfg áiudfhioasudbf oiasugfiuasgfiusdgfiuas fgiausfg ioasugfoiaus",
        feedReplyOwnerUid: "12342",
        feedOwnerUid: "8273492",
        timestamp: Timestamp(),
        feed: feed,
        replyUser: user
    )
}
