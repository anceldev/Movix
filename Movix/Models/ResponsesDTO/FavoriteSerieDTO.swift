//
//  FavoriteSerieDTO.swift
//  Movix
//
//  Created by Ancel Dev account on 23/4/25.
//

import Foundation

struct FavoriteSingleSerieDTO: RatedMediaDTOProtocol {
    var id: Int?
    var userId: UUID
    var mediaId: Int
    var rate: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, rate
        case userId = "user_id"
        case mediaId = "serie_id"
    }
    
    init(id: Int? = nil, userId: UUID, mediaId: Int, rate: Int? = nil) {
        self.id = id
        self.userId = userId
        self.mediaId = mediaId
        self.rate = rate
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.userId = try container.decode(UUID.self, forKey: .userId)
        self.mediaId = try container.decode(Int.self, forKey: .mediaId)
        self.rate = try container.decodeIfPresent(Int.self, forKey: .rate)
    }
}

struct FavoriteSingleMovieDTO: RatedMediaDTOProtocol {
    var id: Int?
    var userId: UUID
    var mediaId: Int
    var rate: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, rate
        case userId = "user_id"
        case mediaId = "movie_id"
    }
    
    init(id: Int? = nil, userId: UUID, mediaId: Int, rate: Int? = nil) {
        self.id = id
        self.userId = userId
        self.mediaId = mediaId
        self.rate = rate
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.userId = try container.decode(UUID.self, forKey: .userId)
        self.mediaId = try container.decode(Int.self, forKey: .mediaId)
        self.rate = try container.decodeIfPresent(Int.self, forKey: .rate)
    }
}
