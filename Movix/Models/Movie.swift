//
//  Movie.swift
//  Movix
//
//  Created by Ancel Dev account on 23/10/23.
//

import Foundation
protocol MediaProtocol: Encodable, Decodable, Identifiable {
    var id: Int { get set }
    var adult: Bool? { get set }
    var backdropPath: String? { get set }
    var posterPath: String? { get set }
    
}

struct Movie: MediaProtocol{
    
    var id: Int
    var adult: Bool?
    var title: String?
    var backdropPath: String?
    var posterPath: String?
    var genres: [Genre]?
    var releaseDate: String?
    var runtime: Int?
    var overview: String?
    
    var spokenLanguages: [Language]?
    var voteAverage: Double?
    
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate ?? "0000-00-00") else {
            return nil
        }
        return date
    }
    
    init(id: Int = 0, adult: Bool? = nil, title: String? = nil, backdropPath: String? = nil, posterPath: String? = nil, genres: [Genre]? = nil, releaseDate: String? = nil, runtime: Int? = nil, overview: String? = nil, spokenLanguages: [Language]? = nil, voteAverage: Double? = nil) {
        self.id = id
        self.adult = adult
        self.title = title
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.genres = genres
        self.releaseDate = releaseDate
        self.runtime = runtime
        self.overview = overview
        self.spokenLanguages = spokenLanguages
        self.voteAverage = voteAverage
    }
    init(origin: Movie) {
        self.id = origin.id
        self.adult = origin.adult
        self.title = origin.title
        self.backdropPath = origin.backdropPath
        self.posterPath = origin.posterPath
        self.genres = origin.genres
        self.releaseDate = origin.releaseDate
        self.runtime = origin.runtime
        self.overview = origin.overview
        self.spokenLanguages = origin.spokenLanguages
        self.voteAverage = origin.voteAverage
    }
    
//    var imageUrl: URL {
//        let baseUrl = "https://image.tmdb.org/t/p/"
//        let width = "w780"
//        let url = baseUrl + width + (backdropPath ?? "")
//        return URL(string: url)!
//    }
    
//    struct Credits: Codable, Identifiable{
//        let id: Int
//        let cast: [Actor]
//    }
//    
//    struct Actor: Codable, Identifiable{
//        let id: Int
//        let name: String
//        let profilePath: String?
//        let gender: Int
//        var rol: String {
//            if gender == 2 {
//                return "Actor"
//            } else if gender == 1{
//                return "Actress"
//            } else {
//                return ""
//            }
//        }
//    }
}

