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
    
    var favoriteMovies: [Movie]
    var ratedMovies: [Movie]
    
    
    var favoriteSeries: [TvSerie]
    var ratedSeries: [TvSerie]
    var newRatedSeries: [RatedSeriesListDTO]
    var newRatedMovies: [RatedMoviesListDTO]
    var newFavoriteMovies: [FavoriteSingleMovieDTO]
    var newFavoriteSeries: [RatedSeriesListDTO]
//    var series: [UserSerie]
    var series: [TestUserSerie]
//    var movies: [UserMovie]
    var movies: [TestUserMovie]
    
    var lists: [SupList]
    
    var avatarPathURl: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(avatarPath ?? "")")!
    }
    
    enum CodingKeys: String, CodingKey {
        case id, fullname, username, email, lang, country
        case avatarPath = "avatar_path"
    }
    
    init(id: UUID, name: String? = nil, username: String, email: String, lang: String = "en", country: String = "US", avatarPath: String?, favoriteMovies: [Movie] = [], ratedMovies: [Movie] = [], lists: [SupList] = [], ratedSeries: [TvSerie] = [], favoriteSeries: [TvSerie] = [], newRatedSeries: [RatedSeriesListDTO] = [], newRatedMovies: [RatedMoviesListDTO] = []) {
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
        
        self.newRatedSeries = newRatedSeries
        self.newRatedMovies = newRatedMovies
        self.newFavoriteMovies = []
        self.newFavoriteSeries = []
        self.series = []
        self.movies = []
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
        
        self.favoriteMovies = []
        self.ratedMovies = []
        self.ratedSeries = []
        self.favoriteSeries = []
        self.lists = []
        
        self.newRatedSeries = []
        self.newRatedMovies = []
        self.newFavoriteMovies = []
        self.newFavoriteSeries = []
        self.series = []
        self.movies = []
    }
    
}
