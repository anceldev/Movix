//
//  TvSerie.swift
//  Movix
//
//  Created by Ancel Dev account on 1/11/23.
//

import Foundation

struct Season: Codable, Identifiable {
    let airDate: String?
    let episodes: [Episode]?
    let name: String?
    let overview: String?
    let id: Int
    let posterPath: String?
    let seasonNumber: Int?
    let voteAverage: Double?
}


struct Serie: Codable, Identifiable {
    let adult: Bool?
    let backdropPath: String?
    //let createdBy: String?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [Genre]?
    let homepage: String?
    let id: Int
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: String
    //let lastEpisodeToAir: String?
    
    let namme: String
    //let nextEpisodeToAir: String?
    
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?
    let originCountry: [String]?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    
    //let productionCompanies: String?
    //let seasons: [Season]?
    let spokenLanguages: [Language]?
    let voteAverage: Double?
    let voteCount: Double?
}

struct Episode: Codable, Identifiable {
    let airDate: String?
    //let crew: [Crew]?
    let episodeNumber: Int?
    //let guestStars: [GuestStar]?
    let name: String
    let overview: String?
    let id: Int
    //let productionCode: String?
    let runtime: Int?
    let seasonNumber: Int?
    let stillPath: String?
    let voteAverage: Double?
    let voteCount: Double?
}
