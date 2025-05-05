//
//  TvSeason.swift
//  Movix
//
//  Created by Ancel Dev account on 27/2/25.
//

import Foundation
import SwiftUI

struct TvSeason: Codable, Identifiable {
    var id: Int
    var airDate: Date?
    var name: String
    var overview: String?
    var posterPath: String?
    var seasonNumer: Int
    var voteAverage: Double?
    var episodeCount: Int?
    var episodes: [TvEpisode]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case airDate = "air_date"
        case name
        case overview
        case posterPath = "poster_path"
        case seasonNumer = "season_number"
        case voteAverage = "vote_average"
        case episodeCount = "episode_count"
        case episodes
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)

        if let airDateString = try container.decodeIfPresent(String.self, forKey: .airDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.airDate = dateFormatter.date(from: airDateString)
        }
        
        self.name = try container.decode(String.self, forKey: .name)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.seasonNumer = try container.decode(Int.self, forKey: .seasonNumer)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.episodeCount = try container.decodeIfPresent(Int.self, forKey: .episodeCount)
        self.episodes = try container.decodeIfPresent([TvEpisode].self, forKey: .episodes)
    }
    
    init(id: Int, airDate: String? = nil, name: String, overview: String? = nil, posterPath: String? = nil, seasonNumer: Int, voteAverage: Double? = nil, episodeCount: Int, episodes: [TvEpisode] = []) {
        self.id = id
        if let airDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.airDate = dateFormatter.date(from: airDate)
        }
        self.name = name
        self.overview = overview
        self.posterPath = posterPath
        self.seasonNumer = seasonNumer
        self.voteAverage = voteAverage
        self.episodeCount = episodeCount
        self.episodes = episodes
    }
}
