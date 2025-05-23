//
//  User.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import Foundation
//import Supabase

enum FriendshipStatus: String, Decodable {
    case pending
    case accepted
    case denied
}

struct User: Codable, Identifiable {
    var id: UUID
    var username: String
    var fullname: String?
    var lang: String
    var email: String
    var country: String
    var avatarPath: String?
    var avatarData: Data?

    var series: [TestUserMedia]
    var movies: [TestUserMedia]
    
    var friends: [Friend]
    var requestsSended: [Friend]
    var requestsReceived: [Friend]
    
    var lists: [MediaList]
    
    var avatarPathURl: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(avatarPath ?? "")")!
    }
    
    enum CodingKeys: String, CodingKey {
        case id, fullname, username, email, lang, country
        case avatarPath = "avatar_path"
    }
    
    init(id: UUID, name: String? = nil, username: String, email: String, lang: String = "en", country: String = "US", avatarPath: String?, lists: [MediaList] = []) {
        self.id = id
        self.fullname = name
        self.username = username
        self.email = email
        self.lang = lang
        self.country = country
        self.avatarPath = avatarPath
        

        self.lists = lists


        self.series = []
        self.movies = []
        self.friends = []
        self.requestsSended = []
        self.requestsReceived = []
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.fullname = try container.decodeIfPresent(String.self, forKey: .fullname)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        
        let userLang = try container.decodeIfPresent(String.self, forKey: .lang)
        self.lang = userLang ?? "en"
        let userCountry = try container.decodeIfPresent(String.self, forKey: .country)
        self.country = userCountry ?? "US"
        
        self.avatarPath = try container.decodeIfPresent(String.self, forKey: .avatarPath)
        
        self.lists = []
        
        self.series = []
        self.movies = []
        self.friends = []
        self.requestsSended = []
        self.requestsReceived = []
    }
    
}

struct Friend {
    var id: Int?
    var friend: User
    var status: FriendshipStatus
}
