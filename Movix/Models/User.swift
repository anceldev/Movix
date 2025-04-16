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
    
    var favoriteMovies: [Movie]
    var ratedMovies: [Movie]
    
    var favoriteSeries: [TvSerie]
    var ratedSeries: [TvSerie]
    
    var lists: [SupList]
    
    var avatarPathURl: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(avatarPath ?? "")")!
    }
    
    enum CodingKeys: String, CodingKey {
        case id, fullname, username, email, lang, country
        case avatarPath = "avatar_path"
    }
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case username
//        case lang = "iso_639_1"
//        case country = "iso_3166_1"
//        case avatar
//        
//        enum AvatarType: String, CodingKey {
//            case tmdb
//            
//            enum AvatarPath: String, CodingKey {
//                case avatarPath = "avatar_path"
//            }
//        }
//    }
    
    init(id: UUID, name: String? = nil, username: String, email: String, lang: String = "en", country: String = "US", avatarPath: String?, favoriteMovies: [Movie] = [], ratedMovies: [Movie] = [], lists: [SupList] = [], ratedSeries: [TvSerie] = [], favoriteSeries: [TvSerie] = []) {
        self.id = id
        self.fullname = name
        self.username = username
        self.email = email
        self.lang = lang
        self.country = country
        self.avatarPath = avatarPath
        
        self.favoriteMovies = favoriteMovies
        self.ratedMovies = ratedMovies
        self.lists = lists
        self.ratedSeries = ratedSeries
        self.favoriteSeries = favoriteSeries
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.fullname = try container.decodeIfPresent(String.self, forKey: .fullname)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.lang = try container.decode(String.self, forKey: .lang)
        self.country = try container.decode(String.self, forKey: .country)
        self.avatarPath = try container.decodeIfPresent(String.self, forKey: .avatarPath)
//        let avatarContainer = try container.nestedContainer(keyedBy: CodingKeys.AvatarType.self, forKey: .avatar)
//        let tmdbAvatarContainer = try avatarContainer.nestedContainer(keyedBy: CodingKeys.AvatarType.AvatarPath.self, forKey: .tmdb)
//        if let avatarPath = try tmdbAvatarContainer.decodeIfPresent(String.self, forKey: .avatarPath) {
//            self.avatarPath = "https://image.tmdb.org/t/p/w500" + avatarPath
//        }
        
        self.favoriteMovies = []
        self.ratedMovies = []
        self.ratedSeries = []
        self.favoriteSeries = []
        self.lists = []
    }
    
//    func encode(to encoder: any Encoder) throws {
//    }
}
extension User {
    static var preview = User(
        id: UUID(),
        name: "dani",
        username: "daniMovix",
        email: "danimovix@mail.com",
        avatarPath: "/72wNvkVfHxJ0NhY0PmogcDR1BNg.png"
    )
}
