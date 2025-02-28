//
//  TvEpisode.swift
//  Movix
//
//  Created by Ancel Dev account on 27/2/25.
//

import Foundation

struct TvEpisode: Codable {
    let id: Int
    let airDate: String
    let episodeNumber: Int
    let name: String
    let overview: String?
    let stillPath: String?
    let seasonNumber: Int
    let voteAverage: Double
    let runtime: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case airDate = "air_date"
        case episodeNumber
        case name
        case overview
        case stillPath = "still_path"
        case seasonNumber
        case voteAverage
        case runtime
    }
}
