//
//  Language.swift
//  Movix
//
//  Created by Ancel Dev account on 26/2/25.
//

import Foundation

struct Language: Codable {
    var iso6391: String
    var englishName: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso_639_1"
        case englishName = "english_name"
        case name
    }
}
