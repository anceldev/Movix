//
//  Country.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation

struct Country: Codable {
    var iso31661: String
    var englishName: String
    var nativeName: String
    
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case englishName = "english_name"
        case nativeName = "native_name"
    }
    
    init() {
        self.iso31661 = ""
        self.englishName = "United States of America"
        self.nativeName = "United States"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.iso31661 = try container.decode(String.self, forKey: .iso31661)
        self.englishName = try container.decode(String.self, forKey: .englishName)
        self.nativeName = try container.decode(String.self, forKey: .nativeName)
    }
}
