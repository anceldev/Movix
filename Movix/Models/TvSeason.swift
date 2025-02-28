//
//  TvSeason.swift
//  Movix
//
//  Created by Ancel Dev account on 27/2/25.
//

import Foundation

struct TvSeason: Codable, Identifiable {
    var id: Int
    var airDate: String?
    var name: String
    var overview: String?
    var posterPath: String?
    var seasonNumer: Int
    var voteAverage: Double?
    var episodeCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case airDate = "air_date"
        case name
        case overview
        case posterPath = "poster_path"
        case seasonNumer = "season_number"
        case voteAverage = "vote_average"
        case episodeCount = "episode_count"
    }
}
