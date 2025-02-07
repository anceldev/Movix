//
//  Cast.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation

struct Credit: Identifiable, Codable {
    let id: Int
    let cast: [Cast]
    
    enum CodingKeys: CodingKey {
        case id
        case cast
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.cast = try container.decode([Cast].self, forKey: .cast)
    }
    func encode(to encoder: any Encoder) throws {
        
    }
}

struct Cast: Identifiable, Decodable {
    let id: Int
    let originalName: String
    let profilePath: URL?
    
    init(id: Int, originalName: String, profilePath: URL?) {
        self.id = id
        self.originalName = originalName
        self.profilePath = profilePath
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalName = "original_name"
        case profilePath = "profile_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.originalName = try container.decode(String.self, forKey: .originalName)
        let profile = try container.decodeIfPresent(String.self, forKey: .profilePath)
        self.profilePath = URL(string: "https://image.tmdb.org/t/p/w185\(profile ?? "")")
    }
}
