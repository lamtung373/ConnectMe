//
//  FeedReplyCell.swift
//  ConnectMe
//
//  Created by Tisp on 21/5/24.
//

import SwiftUI

struct FeedReplyCell: View {
    
    let reply: FeedReply
    
    private var user: User? {
        return reply.replyUser
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                CircularProfilelmageView(user: user, size: .small)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(user?.username ?? "")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(reply.timestamp.timestampString())
                            .font(.caption)
                            .foregroundColor(Color(.systemGray2))
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Color(.colorA))
                        }
                    }
                    
                    Text(reply.replyText)
                        .font(.footnote)
                }
            }
            
            Divider()
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    FeedReplyCell()
//}

struct FeedReplyCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedReplyCell(reply: dev.reply)
    }
}
