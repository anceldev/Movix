//
//  User.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import Foundation
//import Supabase

struct User: Codable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var lang: String?
    var avatarPath: String?
    
    var favorites: [Movie]
    var rates: [RatesList]
    var lists: [SupList]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case lang = "iso_639_1"
        case avatar
        
        enum AvatarType: String, CodingKey {
            case tmdb
            
            enum AvatarPath: String, CodingKey {
                case avatarPath = "avatar_path"
            }
        }
    }
    
    init(id: Int, name: String, username: String, lang: String? = nil, avatarPath: String?, favorites: [Movie] = [], rates: [RatesList] = [], lists: [SupList] = []) {
        self.id = id
        self.name = name
        self.username = username
        self.lang = lang
        self.avatarPath = avatarPath
        self.favorites = favorites
        self.rates = rates
        self.lists = lists
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)
        self.lang = try container.decodeIfPresent(String.self, forKey: .lang)
        
        let avatarContainer = try container.nestedContainer(keyedBy: CodingKeys.AvatarType.self, forKey: .avatar)
        let tmdbAvatarContainer = try avatarContainer.nestedContainer(keyedBy: CodingKeys.AvatarType.AvatarPath.self, forKey: .tmdb)
        if let avatarPath = try tmdbAvatarContainer.decodeIfPresent(String.self, forKey: .avatarPath) {
            self.avatarPath = "https://image.tmdb.org/t/p/w500" + avatarPath
        }
        
        self.favorites = []
        self.rates = []
        self.lists = []
    }
    
    func encode(to encoder: any Encoder) throws {
    }
}
extension User {
    static var preview = User(
        id: 1,
        name: "dani",
        username: "daniMovix",
        avatarPath: "/72wNvkVfHxJ0NhY0PmogcDR1BNg.png"
    )
}
