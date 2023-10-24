//
//  Helpers.swift
//  Movix
//
//  Created by Ancel Dev account on 23/10/23.
//

import Foundation

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}
struct ProductionCountry: Codable, Identifiable{
    let iso31661: String
    let name: String
    var id: String {
        iso31661
    }
}
struct Language: Codable, Identifiable {
    let iso6391: String
    let name: String
    var id: String {
        iso6391
    }
}
