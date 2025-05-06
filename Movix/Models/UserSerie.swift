//
//  UserSerie.swift
//  Movix
//
//  Created by Ancel Dev account on 29/4/25.
//

import Foundation

protocol UserItemCollectionMediaProtocol: Identifiable, Codable {
    var id: Int? { get set }
    var userId: UUID { get set }
//    var mediaId: Int { get set }
    var media: SupabaseMedia { get set }
    var isFavorite: Bool { get set }
    var rating: Int? { get set }
}

protocol UserItemCollectionMediaProtocol2: Identifiable, Codable {
    var id: Int? { get set }
    var userId: UUID? { get set }
//    var mediaId: Int { get set }
    var media: SupabaseMedia { get set }
    var isFavorite: Bool { get set }
    var rating: Int? { get set }
}

struct UserSerie: Identifiable, Codable {
    var id: Int?
    var userId: UUID
    var serie: SupabaseMedia
    var isFavorite: Bool
    var rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case serie = "series"
        case isFavorite = "is_favorite"
        case rating
    }
    func encode(to encoder: any Encoder) throws {
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.userId = try container.decode(UUID.self, forKey: .userId)
        self.serie = try container.decode(SupabaseMedia.self, forKey: .serie)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.rating = try container.decodeIfPresent(Int.self, forKey: .rating)
    }
}

struct TestUserSerie: UserItemCollectionMediaProtocol {
    var id: Int?
    var userId: UUID
    var media: SupabaseMedia
    var isFavorite: Bool
    var rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, rating
        case userId = "user_id"
        case media = "series"
        case isFavorite = "is_favorite"
    }
}

struct TestUserMovie: UserItemCollectionMediaProtocol {
    var id: Int?
    var userId: UUID
    var media: SupabaseMedia
    var isFavorite: Bool
    var rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, rating
        case userId = "user_id"
        case media = "movies"
        case isFavorite = "is_favorite"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.rating = try container.decodeIfPresent(Int.self, forKey: .rating)
        self.userId = try container.decode(UUID.self, forKey: .userId)
        self.media = try container.decode(SupabaseMedia.self, forKey: .media)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
}

struct TestUserMedia: UserItemCollectionMediaProtocol2 {
    var id: Int?
    var userId: UUID?
    var media: SupabaseMedia
    var isFavorite: Bool
    var rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, rating
        case userId = "user_id"
        case serie = "serie_id"
        case movie = "movie_id"
        case isFavorite = "is_favorite"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.rating = try container.decodeIfPresent(Int.self, forKey: .rating)
        self.userId = try container.decodeIfPresent(UUID.self, forKey: .userId)
//        self.media = try container.decode(SupabaseMedia.self, forKey: .media)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        
        let serie = try container.decodeIfPresent(SupabaseMedia.self, forKey: .serie)
        if let serie {
            self.media = serie
        } else {
            let movie = try container.decode(SupabaseMedia.self, forKey: .movie)
            self.media = movie
        }
    }
    func encode(to encoder: any Encoder) throws {
        
    }
}

//struct TestUserMedia: UserItemCollectionMediaProtocol {
//    var id: Int?
//    var userId: UUID
//    var media: SupabaseMedia
//    var isFavorite: Bool
//    var rating: Int?
//    
//    enum CodingKeys: String, CodingKey {
//        case id, rating
//        case userId = "user_id"
//        case seriesId = "series_id"
//        case moviesId = "movies_id"
//        case isFavorite = "is_favorite"
//    }
    
    
//
//    init(id: Int? = nil, userId: UUID, media: SupabaseMedia, isFavorite: Bool, rating: Int? = nil) {
//        self.id = id
//        self.userId = userId
//        self.media = media
//        self.isFavorite = isFavorite
//        self.rating = rating
//    }
    
//    init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
//        self.userId = try container.decode(UUID.self, forKey: .userId)
//        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
//        self.rating = try container.decodeIfPresent(Int.self, forKey: .rating)
//        
//        let series = try container.decodeIfPresent(SupabaseMedia.self, forKey: .seriesId)
//        let movies = try container.decodeIfPresent( SupabaseMedia.self, forKey: .moviesId)
//        
//    }
//}
