//
//  MediaList.swift
//  Movix
//
//  Created by Ancel Dev account on 18/2/25.
//

import Foundation

enum ListType: String, Codable, CaseIterable, Hashable, Equatable {
    case movie
    case serie
}

struct MediaList: Codable, Identifiable, Hashable {
    var id: Int?
    var name: String
    var description: String?
    var owner: User?
    var isPublic: Bool
    var listType: ListType
    var items: [SupabaseMedia]
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, items
        case listType = "list_type"
        case owner = "owner_id"
        case isPublic = "is_public"
    }
    
    init(id: Int? = nil, name: String, description: String? = nil, listType: ListType, owner: User?, isPublic: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.listType = listType
        self.owner = owner
        self.isPublic = isPublic
        self.items = []
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.listType = try container.decode(ListType.self, forKey: .listType)
        self.owner = try container.decodeIfPresent(User.self, forKey: .owner)
        self.isPublic = try container.decode(Bool.self, forKey: .isPublic)
        self.items = []
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(listType.rawValue, forKey: .listType)
        try container.encodeIfPresent(owner?.id, forKey: .owner)
        try container.encode(isPublic, forKey: .isPublic)
    }
    
    static func == (lhs: MediaList, rhs: MediaList) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.description == rhs.description &&
        lhs.owner?.id == rhs.owner?.id &&
        lhs.isPublic == rhs.isPublic &&
        lhs.listType == rhs.listType &&
        lhs.items == rhs.items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(owner?.id)
        hasher.combine(isPublic)
        hasher.combine(listType)
        hasher.combine(items)
    }
}
