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
    var country: String?
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
        case id
        case name
        case username
        case lang = "iso_639_1"
        case country = "iso_3166_1"
        case avatar
        
        enum AvatarType: String, CodingKey {
            case tmdb
            
            enum AvatarPath: String, CodingKey {
                case avatarPath = "avatar_path"
            }
        }
    }
    
    init(id: Int, name: String, username: String, lang: String? = nil, avatarPath: String?, favoriteMovies: [Movie] = [], ratedMovies: [Movie] = [], lists: [SupList] = [], ratedSeries: [TvSerie] = [], favoriteSeries: [TvSerie] = []) {
        self.id = id
        self.name = name
        self.username = username
        self.lang = lang
        self.avatarPath = avatarPath
        self.favoriteMovies = favoriteMovies
        self.ratedMovies = ratedMovies
        self.lists = lists
        self.ratedSeries = ratedSeries
        self.favoriteSeries = favoriteSeries
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)
        self.lang = try container.decodeIfPresent(String.self, forKey: .lang)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        let avatarContainer = try container.nestedContainer(keyedBy: CodingKeys.AvatarType.self, forKey: .avatar)
        let tmdbAvatarContainer = try avatarContainer.nestedContainer(keyedBy: CodingKeys.AvatarType.AvatarPath.self, forKey: .tmdb)
        if let avatarPath = try tmdbAvatarContainer.decodeIfPresent(String.self, forKey: .avatarPath) {
            self.avatarPath = "https://image.tmdb.org/t/p/w500" + avatarPath
        }
        
        self.favoriteMovies = []
        self.ratedMovies = []
        self.ratedSeries = []
        self.favoriteSeries = []
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
