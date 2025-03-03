//
//  TvSerie.swift
//  Movix
//
//  Created by Ancel Dev account on 27/2/25.
//

import Foundation

struct TvSerie: Codable, Identifiable, MediaItemProtocol {
    
    
    var isAdult: Bool?
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
    var rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case isAdult = "adult"
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
        case rating
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
        self.isAdult = try container.decodeIfPresent(Bool.self, forKey: .isAdult)
        self.rating = try container.decodeIfPresent(Int.self, forKey: .rating)
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
        voteAverage: Double? = nil
    ) {
        self.id = id
        self.isAdult = isAdult
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.genres = genres
        self.genreIds = genreIds
        self.homePage = homePage
        self.inProduction = inProduction
        self.title = title
        self.numberOfSeasons = numberOfSeasons
        self.numberOfEpisodes = numberOfEpisodes
        self.originalName = originalName
        self.overview = overview
        self.posterPath = posterPath
        self.seasons = seasons
        self.voteAverage = voteAverage
    }
}

extension TvSerie {
    static let that70show = TvSerie(
        isAdult: false,
        backdropPath: "/3zRUiH8erHIgNUBTj05JT00HwsS.jpg",
        releaseDate: DateComponents(year: 1998, month: 8, day: 23).date,
        genres: [
            Genre(id: 35, name: "Comedy"),
            Genre(id: 10751, name: "Family"),
            Genre(id: 18, name: "Drama")
        ],
        genreIds: [35, 10751, 18],
        homePage: URL(string: ""),
        id: 52,
        inProduction: false,
        title: "That '70s Show",
        numberOfSeasons: 8,
        numberOfEpisodes: 200,
        originalName: "That '70s Show",
        overview: "Crank up the 8-track and flash back to a time when platform shoes and puka shells were all the rage in this hilarious retro-sitcom. For Eric, Kelso, Jackie, Hyde, Donna and Fez, a group of high school teens who spend most of their time hanging out in Eric’s basement, life in the ‘70s isn’t always so groovy. But between trying to figure out the meaning of life, avoiding their parents, and dealing with out-of-control hormones, they’ve learned one thing for sure: they’ll always get by with a little help from their friends.",
        posterPath: "/laEZvTqM80UaplUaDSCCbWhlyEV.jpg",
        seasons: [
            TvSeason(id: 94, airDate: "1998-08-23", name: "Season 1", overview: "", posterPath: "/d3jLBFnqub6rYXifgus5fkNt2H6.jpg", seasonNumer: 1, voteAverage: 7.5, episodeCount: 25),
            TvSeason(id: 93, airDate: "1999-09-28", name: "Season 2", overview: "", posterPath: "/6H4WTKooT5cBjFCmNIJKHAJDUEY.jpg", seasonNumer: 2, voteAverage: 7.4, episodeCount: 26),
            TvSeason(id: 92, airDate: "2000-10-03", name: "Season 3", overview: "", posterPath: "/yskd1fDr8CKoX2T0vUKhi8ZB1mp.jpg", seasonNumer: 3, voteAverage: 7.4, episodeCount: 25),
            TvSeason(id: 91, airDate: "2001-09-25", name: "Season 4", overview: "", posterPath: "/buXFywjr5vT4E1USc5hVoRcIaOt.jpg", seasonNumer: 4, voteAverage: 7.3, episodeCount: 25)
        ],
        voteAverage: 7.9
    )
}



