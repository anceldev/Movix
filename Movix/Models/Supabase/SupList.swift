//
//  SupList.swift
//  Movix
//
//  Created by Ancel Dev account on 18/2/25.
//

import Foundation

struct SupList: Codable, Identifiable {
    let id: Int
    let name: String
    let isPublic: Bool?
    let movies: [SupMovie]
    
    enum CodingKeys: String, CodingKey {
        case id, name, movies
        case isPublic = "is_public"
    }
}

struct ListTable: Decodable {
    let user_id: User?
    let name: String
    let isPublic: Bool
}
struct ListMoviesTable: Decodable {
    let list_id: ListTable?
    let movie_id: SupMovie?
}
