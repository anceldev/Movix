//
//  Genre.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation
struct Genres: Codable {
    var genres: [Genre]
    
    init(genres: [Genre] = []) {
        self.genres = genres
    }
}
struct Genre: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
}
