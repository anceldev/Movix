//
//  SupMovie.swift
//  Movix
//
//  Created by Ancel Dev account on 18/2/25.
//

import Foundation

struct SupMovie: Codable, Identifiable, Hashable {
    let id: Int
    let tmdbId: Int
    let backdropPath: String?
    let posterPath: String?
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case tmdbId = "tmdb_id"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }
}

struct FavoritesTable: Decodable {
    let movie: SupMovie
    let user: User?
    
    enum CodingKeys: String, CodingKey {
        case movie = "movie_id"
        case user = "user_id"
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user = try container.decodeIfPresent(User.self, forKey: .user)
        self.movie = try container.decode(SupMovie.self, forKey: .movie)
    }
}
struct RatesList: Decodable {
    let user: User?
    let movie: SupMovie
    let rate: Double?
    
    enum CodingKeys: String, CodingKey {
        case user = "user_id"
        case movie = "movie_id"
        case rate
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user = try container.decodeIfPresent(User.self, forKey: .user)
        self.movie = try container.decode(SupMovie.self, forKey: .movie)
        self.rate = try container.decodeIfPresent(Double.self, forKey: .rate)
    }
}


extension SupMovie {
    static let preview1 = SupMovie(
        id: 1,
        tmdbId: 447365,
        backdropPath: "/5YZbUmjbMa3ClvSW1Wj3D6XGolb.jpg",
        posterPath: "/r2J02Z2OpNTctfOSN1Ydgii51I3.jpg",
        title: "Guardians of the Galaxy Vol. 3"
    )
    static let preview2 = SupMovie(
        id: 2,
        tmdbId: 533535,
        backdropPath: "/by8z9Fe8y7p4jo2YlW2SZDnptyT.jpg",
        posterPath: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
        title: "Deadpool & Wolverine"
    )
}
