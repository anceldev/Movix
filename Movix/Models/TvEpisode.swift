//
//  TvEpisode.swift
//  Movix
//
//  Created by Ancel Dev account on 27/2/25.
//

import Foundation

struct TvEpisode: Codable, Identifiable {
    let id: Int
    let airDate: Date?
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
        case episodeNumber = "episode_number"
        case name
        case overview
        case stillPath = "still_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
        case runtime
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
//        self.airDate = try container.decodeIfPresent(Date.self, forKey: .airDate)
        if let airDateString = try container.decodeIfPresent(String.self, forKey: .airDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.airDate = dateFormatter.date(from: airDateString)
        }
        else {
            self.airDate = nil
        }
        
        self.episodeNumber = try container.decode(Int.self, forKey: .episodeNumber)
        self.name = try container.decode(String.self, forKey: .name)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.stillPath = try container.decodeIfPresent(String.self, forKey: .stillPath)
        self.seasonNumber = try container.decode(Int.self, forKey: .seasonNumber)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
    }
    
    init (
    id: Int,
    airDate: Date?,
    episodeNumber: Int,
    name: String,
    overview: String?,
    stillPath: String?,
    seasonNumber: Int,
    voteAverage: Double,
    runtime: Int?)
    {
        self.id = id
        self.airDate = airDate
        self.episodeNumber = episodeNumber
        self.name = name
        self.overview = overview
        self.stillPath = stillPath
        self.seasonNumber = seasonNumber
        self.voteAverage = voteAverage
        self.runtime = runtime
    }
}


extension TvEpisode {
    // Preview based on the pilot episode
    static let pilotPreview = TvEpisode(
        id: 1596,
        airDate: DateFormatter.yearMonthDay.date(from: "1998-08-23"),
        episodeNumber: 1,
        name: "That '70s Pilot",
        overview: "While Eric Forman is swiping beer for his best friends Donna Pinciotti, Michael Kelso, and Steven Hyde, his parents Red and Kitty hint that he may be getting the old Vista Cruiser.",
        stillPath: "/rCu8eTlNaYOydOegoOXEDItspE8.jpg",
        seasonNumber: 1,
        voteAverage: 7.2,
        runtime: 23
    )
    
    // Preview based on a regular episode
    static let regularPreview = TvEpisode(
        id: 1595,
        airDate: DateFormatter.yearMonthDay.date(from: "1998-08-30"),
        episodeNumber: 2,
        name: "Eric's Birthday",
        overview: "Eric's 17th birthday is coming up and he really doesn't want a party.",
        stillPath: "/gD8vFYJwqneVsosxUedsrNEO3rf.jpg",
        seasonNumber: 1,
        voteAverage: 7.3,
        runtime: 23
    )
}
extension DateFormatter {
    static let yearMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
