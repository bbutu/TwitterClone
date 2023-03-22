//
//  Tweet.swift
//  TwitterClone
//
//  Created by Beka Buturishvili on 03.02.23.
//

import Foundation

struct Tweet: Codable {
    var id = UUID().uuidString
    let author: TwitterUser
    let authorID: String
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
}
