//
//  UserMovie.swift
//  Movix
//
//  Created by Ancel Dev account on 29/4/25.
//

import Foundation

struct UserMovie: Identifiable, Codable {
    var id: Int?
    var userId: UUID
    var movie: SupabaseMedia
    var isFavorite: Bool
    var rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case movie = "movies"
        case isFavorite = "is_favorite"
        case rating
    }
    func encode(to encoder: any Encoder) throws {
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.userId = try container.decode(UUID.self, forKey: .userId)
        self.movie = try container.decode(SupabaseMedia.self, forKey: .movie)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.rating = try container.decodeIfPresent(Int.self, forKey: .rating)
    }
}
