//
//  RatedSingleSerieDTO.swift
//  Movix
//
//  Created by Ancel Dev account on 22/4/25.
//

import Foundation

protocol RatedMediaDTOProtocol: Identifiable, Codable {
    var id: Int? { get set }
    var userId: UUID { get set }
    var mediaId: Int { get set }
    var rate: Int? { get set }
}

struct RatedSingleSerieDTO: RatedMediaDTOProtocol {
    var id: Int?
    var userId: UUID
    var mediaId: Int
    var rate: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, rate
        case userId = "user_id"
        case mediaId = "serie_id"
    }
    
    init(id: Int? = nil, userId: UUID, mediaId: Int, rate: Int) {
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
struct RatedSingleMovieDTO: RatedMediaDTOProtocol {
    var id: Int?
    var userId: UUID
    var mediaId: Int
    var rate: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, rate
        case userId = "user_id"
        case mediaId = "movie_id"
    }
    
    init(id: Int? = nil, userId: UUID, mediaId: Int, rate: Int) {
        self.id = id
        self.userId = userId
        self.mediaId = mediaId
        self.rate = rate
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.userId = try container.decode(UUID.self, forKey: .userId)
        self.mediaId = try container.decode(Int.self, forKey: .mediaId)
        self.rate = try container.decodeIfPresent(Int.self, forKey: .rate)
    }
}

enum SupabaseMediaCodingKeys: String, Decodable {
    case movie
    case serie_id

    var idKey: String {
        switch self {
            case .movie: return "movie_id"
            case .serie_id: return "serie_id"
        }
    }
}

//
//struct RatedMovieDTO: RatedListDTOProtocol {
//    var id: Int?
//    var userId: UUID
//    var media: SupabaseMedia
//    var rate: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id, rate
//        case userId = "user_id"
//        case media = "movies"
//    }
//
//    static var mediaFieldName: String = "movies"
//}



