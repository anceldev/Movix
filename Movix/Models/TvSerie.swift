//
//  TvSerie.swift
//  Movix
//
//  Created by Ancel Dev account on 27/2/25.
//

import Foundation

struct TvSerie: Codable, Identifiable, MediaItemProtocol {
    var backdropPath: String?
    var releaseDate: Date? // First air date
    var genres: [Genre]?
    var genreIds: [Int]?
    var homePage: URL?
    var id: Int
    var inProduction: Bool?
    var title: String // name
    var numberOfSeasons: Int?
    var numberOfEpisodes: Int?
    var originalName: String
    var overview: String?
    var posterPath: String?
    var seasons: [TvSeason]?
    var voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case releaseDate = "first_air_date"
        case genres
        case genreIds = "genre_ids"
        case homePage
        case id
        case inProduction = "in_production"
        case title = "name"
        case overview
        case originalName = "original_name"
        case numberOfSeasons = "number_of_seasons"
        case numberOfEpisodes = "number_of_episodes"
        case seasons
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
//        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        
        if let releasedOn = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.releaseDate = dateFormatter.date(from: releasedOn)
        }
        self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
        self.genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds)
        self.homePage = try container.decodeIfPresent(URL.self, forKey: .homePage)
        self.id = try container.decode(Int.self, forKey: .id)
        self.inProduction = try container.decodeIfPresent(Bool.self, forKey: .inProduction)
        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.originalName = try container.decode(String.self, forKey: .originalName)
        self.numberOfSeasons = try container.decodeIfPresent(Int.self, forKey: .numberOfSeasons)
        self.numberOfEpisodes = try container.decodeIfPresent(Int.self, forKey: .numberOfEpisodes)
        self.seasons = try container.decodeIfPresent([TvSeason].self, forKey: .seasons)
        
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)

        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
    }
}
