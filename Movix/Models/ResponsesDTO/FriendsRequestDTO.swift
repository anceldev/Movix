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

struct FriendshipRequestDTO: Codable, Identifiable {
    var id: Int?
    var user1: UUID
    var user2: UUID
    var status: FriendshipStatus
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case user1 = "user_1"
        case user2 = "user_2"
    }
    
    init(id: Int? = nil, user1: UUID, user2: UUID, status: FriendshipStatus = .pending) {
        self.id = id
        self.user1 = user1
        self.user2 = user2
        self.status = status
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(user1, forKey: .user1) // Se codificará como "user_1"
        try container.encode(user2, forKey: .user2) // Se codificará como "user_2"
        try container.encode(status.rawValue, forKey: .status) // Se codificará como
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.status = try container.decode(FriendshipStatus.self, forKey: .status)
        self.user1 = try container.decode(UUID.self, forKey: .user1)
        self.user2 = try container.decode(UUID.self, forKey: .user2)
    }
}

struct FriendshipResponseDTO: Codable, Identifiable {
    var id: Int?
    var user1: User // Usuario emisor de solicitud
    var user2: User // Usuario receptor de solicitud
    var status: FriendshipStatus
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case user1 = "user_1"
        case user2 = "user_2"
    }
    
    init(id: Int? = nil, user1: User, user2: User, status: FriendshipStatus = .pending) {
        self.id = id
        self.user1 = user1
        self.user2 = user2
        self.status = status
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(user1, forKey: .user1) // Se codificará como "user_1"
        try container.encode(user2, forKey: .user2) // Se codificará como "user_2"
        try container.encode(status.rawValue, forKey: .status) // Se codificará como
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.status = try container.decode(FriendshipStatus.self, forKey: .status)
        self.user1 = try container.decode(User.self, forKey: .user1)
        self.user2 = try container.decode(User.self, forKey: .user2)
    }
}
