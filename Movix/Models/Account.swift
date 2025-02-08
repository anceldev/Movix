//
//  Account.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import Foundation
import Supabase

struct Account: Codable, Identifiable {
    let id: UUID
    let username: String
    let email: String
    let lang: String?
    var movies: [SupMovie]
    
    init(id: UUID, username: String, email: String, lang: String? = nil, movies: [SupMovie] = []) {
        self.id = id
        self.username = username
        self.email = email
        self.lang = lang
        self.movies = movies
    }
}

struct UserMetadata: Codable {
    var username: String
    var lang: String
}

struct SupMovie: Codable, Identifiable {
    let id: Int
    let movieId: Int
    let rating: Float?
    let favorite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case movieId = "movie_id"
        case rating
        case favorite
    }
}
