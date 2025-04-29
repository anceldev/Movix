//
//  SupabaseMedia.swift
//  Movix
//
//  Created by Ancel Dev account on 23/4/25.
//

import Foundation

struct SupabaseMedia: Decodable, MediaSupabaseProtocol {
    var id: Int
    var posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
    }
    
    init(id: Int, posterPath: String?) {
        self.id = id
        self.posterPath = posterPath
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(posterPath, forKey: .posterPath)
    }
}
