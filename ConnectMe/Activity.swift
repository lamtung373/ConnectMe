//
//  Activity.swift
//  ConnectMe
//
//  Created by Tisp on 23/5/24.
//

import Foundation
import FirebaseFirestoreSwift

struct Activity: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var activityFor: String
    var type: String
    var timestamp: Date
    var details: [String: String]

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case activityFor
        case type
        case timestamp
        case details
    }
}
