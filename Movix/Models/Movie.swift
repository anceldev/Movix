//
//  Movie.swift
//  Movix
//
//  Created by Ancel Dev account on 23/10/23.
//

import Foundation

struct Movie: Encodable, Decodable, Identifiable{
    let id: Int
    let adult: Bool?
    let title: String?
    let backdropPath: String?
    let posterPath: String?
    let genres: [Genre]?
    let releaseDate: String?
    let runtime: Int?
    let overview: String?
    
    //var credits: Credits?
//    let budget: Double?
    let spokenLanguages: [Language]?
    let voteAverage: Double?
    
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate ?? "0000-00-00") else {
            return nil
        }
        return date
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

