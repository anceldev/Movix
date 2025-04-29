//
//  UserSerieResponseDTO.swift
//  Movix
//
//  Created by Ancel Dev account on 29/4/25.
//


import Foundation

struct UserSerieResponseDTO: Identifiable, Codable {
    var id: Int?
    var userId: UUID
    var mediaId: Int
    var isFavorite: Bool
    var rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case mediaId = "serie_id"
        case isFavorite = "is_favorite"
        case rating
    }
    
    init(id: Int? = nil, userId: UUID, serieId: Int, isFavorite: Bool = false, rating: Int? = nil) {
        self.id = id
        self.userId = userId
        self.mediaId = serieId
        self.isFavorite = isFavorite
        self.rating = rating
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.userId = try container.decode(UUID.self, forKey: .userId)
        self.mediaId = try container.decode(Int.self, forKey: .mediaId)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.rating = try container.decodeIfPresent(Int.self, forKey: .rating)
    }
}
