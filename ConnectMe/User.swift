//
//  User.swift
//  ConnectMe
//
//  Created by Tisp on 29/3/24.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: String?
    var bio: String?
    var link: String?
    var followers: [String] = []
    var following: [String] = []
    var isPrivate: Bool = false
}
