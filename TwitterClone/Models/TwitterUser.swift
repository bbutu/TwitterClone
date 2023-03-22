//
//  TwitterUser.swift
//  TwitterClone
//
//  Created by Beka Buturishvili on 23.12.22.
//

import Foundation
import Firebase

struct TwitterUser: Codable {
    let id: String
    var displayName: String = ""
    var userName: String = ""
    var followersCount: Int = 0
    var followingCount: Int = 0
    var createdOn: Date = Date()
    var bio: String = ""
    var avatarPath: String = ""
    var isUserOnboarded: Bool = false
    
    
    init(from user: User) {
        self.id = user.uid
    }
    
}
