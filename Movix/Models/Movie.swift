//
//  Movie.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation


struct Movie: Codable, Identifiable, Hashable, MediaItemProtocol {
    var id: Int
    var title: String
    var originalTitle: String?
    var overview: String?
    var runtime: Int?
    var releaseDate: Date?
    var posterPathUrl: URL?
    var posterPath: String?
    var genres: [Genre]?
    var genreIds: [Int]?
    var backdropPath: String?
    var budget: Double?
    var homepage: URL?
    var popularity: Double?
    var voteAverage: Double?
    var voteCount: Int?
    var isAdult: Bool?
    var rating: Int?
    var originCountry: [String]
    var status: String?
    
    var character: String?
    
    var duration: String {
        guard let runtime else {
            return ""
        }
        return "\(runtime/60)h \(runtime%60)min"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case genres
        case genreIds = "genre_ids"
        case originalTitle = "original_title"
        case overview
        case runtime
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case budget
        case homepageURL = "homepage"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case isAdult = "adult"
        case rating
        case originCountry = "origin_country"
        case status
        
        
        case character
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        
        if let releasedOn = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.releaseDate = dateFormatter.date(from: releasedOn)
        }
        
        let posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.posterPath = posterPath
        self.posterPathUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")
        
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        //        self.backdropPath = URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath ?? "")")
        
        self.budget = try container.decodeIfPresent(Double.self, forKey: .budget)
        if let homePageString = try container.decodeIfPresent(String.self, forKey: .homepageURL) {
            self.homepage = URL(string: homePageString)
        }
        else {
            self.homepage = nil
        }
        //        self.homepage = try container.decodeIfPresent(URL.self, forKey: .homepage)
        //        self.homepage = nil
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.isAdult = try container.decodeIfPresent(Bool.self, forKey: .isAdult)
        self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
        self.genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds)
        self.rating = try container.decodeIfPresent(Int.self, forKey: .rating)
        //        self.genreIds = try container.decode([Int].self, forKey: .genreIds)
        
        let originCountry = try container.decodeIfPresent([String].self, forKey: .originCountry)
        self.originCountry = originCountry != nil ? originCountry! : []
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        
        
        self.character = try container.decodeIfPresent(String.self, forKey: .character)
    }
    
    func encode(to encoder: any Encoder) throws { }
}

extension Movie {
    
    init(id: Int,
         title: String,
         originalTitle: String? = nil,
         overview: String? = nil,
         runtime: Int? = nil,
         releaseDate: Date? = nil,
         posterPath: String? = nil,
         backdropPath: String? = nil,
         genres: [Genre] = [],
         budget: Double? = nil,
         homepageURL: URL? = nil,
         popularity: Double? = nil,
         voteAverage: Double? = nil,
         voteCount: Int? = nil,
         isAdult: Bool? = nil,
         originCountry: [String] = [],
         status: String = ""
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.runtime = runtime
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.genres = genres
        self.budget = budget
        self.homepage = homepageURL
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.isAdult = isAdult
        self.genres = []
        self.originCountry = originCountry
        self.status = status
    }
    
    static var preview: Movie = .init(
        id: 533535,
        title: "Deadpool & Wolverine",
        originalTitle: "Deadpool & Wolverine",
        overview: "A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.",
        runtime: 128,
        releaseDate: .now,
        posterPath: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
        backdropPath: "/9l1eZiJHmhr5jIlthMdJN5WYoff.jpg",
        genres: [.init(id: 1, name: "Action"), .init(id: 2, name: "Hero")],
        budget: 250000000,
        homepageURL: URL(string: "https://www.marvel.com/movies/deadpool-and-wolverine"),
        popularity: 2178.995,
        voteAverage: 8.202,
        voteCount: 141,
        isAdult: false,
        originCountry: ["US"],
        status: "Released"
    )
}
