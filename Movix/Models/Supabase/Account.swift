//
//  Account.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import Foundation
import Supabase

struct Account: Codable, Identifiable {
    var id: UUID
    let username: String
    let email: String
    let lang: String?
    
    var favorites: [SupMovie]
    var rates: [RatesList]
    var lists: [SupList]
    
    init(id: UUID, username: String, email: String, lang: String? = nil, favorites: [SupMovie] = [], rates: [RatesList] = [], lists: [SupList] = []) {
        self.id = id
        self.username = username
        self.email = email
        self.lang = lang
        self.favorites = favorites
        self.rates = rates
        self.lists = lists
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.lang = try container.decodeIfPresent(String.self, forKey: .lang)
        
        self.favorites = []
        self.rates = []
        self.lists = []
    }
    enum CodingKeys: CodingKey {
        case id
        case username
        case email
        case lang
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.email, forKey: .email)
        try container.encodeIfPresent(self.lang, forKey: .lang)
    }
}
extension Account {
    static var preview = Account(
        id: UUID(uuidString: "f27ca4f7-fbab-4aa2-9a79-dc43b721024c") ?? UUID(),
        username: "dani",
        email: "dani@mail.com"
    )
}

struct UserMetadata: Codable {
    var username: String
    var lang: String
}
