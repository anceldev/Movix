//
//  TvSerie.swift
//  Movix
//
//  Created by Ancel Dev account on 27/2/25.
//

import Foundation

struct TvSerie: Codable, Identifiable, MediaTMDBProtocol {
    var isAdult: Bool?
    var backdropPath: String?
    var releaseDate: Date? // First air date
    var genres: [Genre]?
    var genreIds: [Int]?
    var homepage: URL?
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
    var rating: Int?
    var originCountry: [String]
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case isAdult = "adult"
        case backdropPath = "backdrop_path"
        case releaseDate = "first_air_date"
        case genres
        case genreIds = "genre_ids"
        case homepage
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
        case rating
        case originCountry = "origin_country"
        case status
    }
    

    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        
        if let releasedOn = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.releaseDate = dateFormatter.date(from: releasedOn)
        }
        self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
        self.genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds)

        if let homePageString = try container.decodeIfPresent(String.self, forKey: .homepage) {
            self.homepage = URL(string: homePageString)
        }
        else {
            self.homepage = nil
        }
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
        self.isAdult = try container.decodeIfPresent(Bool.self, forKey: .isAdult)
        self.rating = try container.decodeIfPresent(Int.self, forKey: .rating)
        
        let originCountry = try container.decodeIfPresent([String].self, forKey: .originCountry)
        self.originCountry = originCountry != nil ? originCountry! : []
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
    }
    init(
        isAdult: Bool? = nil,
        backdropPath: String? = nil,
        releaseDate: Date? = nil,
        genres: [Genre]? = nil,
        genreIds: [Int]? = nil,
        homePage: URL? = nil,
        id: Int,
        inProduction: Bool? = nil,
        title: String,
        numberOfSeasons: Int? = nil,
        numberOfEpisodes: Int? = nil,
        originalName: String,
        overview: String? = nil,
        posterPath: String? = nil,
        seasons: [TvSeason]? = nil,
        voteAverage: Double? = nil,
        originCountry: [String] = [],
        status: String = ""
    ) {
        self.id = id
        self.isAdult = isAdult
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.genres = genres
        self.genreIds = genreIds
        self.homepage = homePage
        self.inProduction = inProduction
        self.title = title
        self.numberOfSeasons = numberOfSeasons
        self.numberOfEpisodes = numberOfEpisodes
        self.originalName = originalName
        self.overview = overview
        self.posterPath = posterPath
        self.seasons = seasons
        self.voteAverage = voteAverage
        self.originCountry = originCountry
        self.status = status
    }
}



