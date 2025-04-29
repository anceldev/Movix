//
//  RatedSingleSerieDTO.swift
//  Movix
//
//  Created by Ancel Dev account on 22/4/25.
//

import Foundation

struct RatedSeriesListDTO: RatedListDTOProtocol {
    var id: Int?
    var userId: UUID
    var media: SupabaseMedia
    var rate: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, rate
        case userId = "user_id"
        case media = "series"
    }
    
    init(id: Int? = nil, userId: UUID, media: SupabaseMedia, rate: Int? = nil) {
        self.id = id
        self.userId = userId
        self.media = media
        self.rate = rate
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.rate = try container.decodeIfPresent(Int.self, forKey: .rate)
        self.userId = try container.decode(UUID.self, forKey: .userId)
        self.media = try container.decode(SupabaseMedia.self, forKey: .media)
    }
}

struct RatedMoviesListDTO: RatedListDTOProtocol {
    var id: Int?
    var userId: UUID
    var media: SupabaseMedia
    var rate: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, rate
        case userId = "user_id"
        case media = "movies"
    }
    
    init(id: Int? = nil, userId: UUID, media: SupabaseMedia, rate: Int? = nil) {
        self.id = id
        self.userId = userId
        self.media = media
        self.rate = rate
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.rate = try container.decodeIfPresent(Int.self, forKey: .rate)
        self.userId = try container.decode(UUID.self, forKey: .userId)
        self.media = try container.decode(SupabaseMedia.self, forKey: .media)
    }
}
