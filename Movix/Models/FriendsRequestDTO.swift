//
//  FriendsDTO.swift
//  Movix
//
//  Created by Ancel Dev account on 16/4/25.
//

import Foundation

struct FriendsRequestDTO: Decodable, Identifiable {
    var id: Int
    var status: FriendshipStatus
    var user: User
    
    enum CodingKeys: String, CodingKey {
        case id,status
        case user = "user_id"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.status = try container.decode(FriendshipStatus.self, forKey: .status)
        self.user = try container.decode(User.self, forKey: .user)
    }
}
