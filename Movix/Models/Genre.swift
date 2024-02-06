//
//  Genre.swift
//  Movix
//
//  Created by Ancel Dev account on 19/1/24.
//

import Foundation

struct Genres: Codable {
    var genres: [Genre]
}

struct Genre: Codable, Identifiable{
    let id: Int
    let name: String
}
