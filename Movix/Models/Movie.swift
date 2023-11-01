//
//  Movie.swift
//  Movix
//
//  Created by Ancel Dev account on 23/10/23.
//

import Foundation

struct Movie: Encodable, Decodable, Identifiable{
    let adult: Bool?
    let title: String?
    let backdropPath: String?
    var id: Int
    let genres: [Genre]?
    let releaseDate: String?
    let runtime: Int?
    let overview: String?
    
    //var credits: Credits?
    let budget: Double?
    let productionCountries: [ProductionCountry]?
    let spokenLanguages: [Language]?
    let voteAverage: Double?
    let voteCount: Int?
    
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate ?? "0000-00-00") else {
            fatalError("Can't get date")
        }
        return date
    }
    
    var imageUrl: URL {
        let baseUrl = "https://image.tmdb.org/t/p/"
        let width = "w780"
        let url = baseUrl + width + (backdropPath ?? "")
        return URL(string: url)!
    }
    
    struct Credits: Codable, Identifiable{
        let id: Int
        let cast: [Actor]
    }
    struct Actor: Codable, Identifiable{
        let id: Int
        let name: String
        let profilePath: String?
        let gender: Int
        var rol: String {
            if gender == 2 {
                return "Actor"
            } else if gender == 1{
                return "Actress"
            } else {
                return ""
            }
        }
    }
}
extension Movie{
    static var test = Movie(adult: false, title: "Oppenheimer", backdropPath: "/fm6KqXpk3M2HVveHwCrBSSBaO0V.jpg", id: 872585, genres: [Genre(id: 18, name: "Drama"), Genre(id: 36, name: "History")], releaseDate: "2023-07-19", runtime: 181, overview: "The story of J. Robert Oppenheimer’s role in the development of the atomic bomb during World War II.", budget: 100000000, productionCountries: [ProductionCountry(iso31661: "GB", name: "United Kingdom"), ProductionCountry(iso31661: "US", name: "United States of America")] ,spokenLanguages: [Language(iso6391: "nl", name: "Dutch") , Language(iso6391: "en", name: "English")], voteAverage: 8.251, voteCount: 3937)
}

