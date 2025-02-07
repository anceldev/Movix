//
//  PageCollection.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation

struct PageCollection<T:Codable>: Codable {
    let id: Int?
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<PageCollection<T>.CodingKeys> = try decoder.container(keyedBy: PageCollection<T>.CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: PageCollection<T>.CodingKeys.id)
        self.page = try container.decode(Int.self, forKey: PageCollection<T>.CodingKeys.page)
        self.results = try container.decode([T].self, forKey: PageCollection<T>.CodingKeys.results)
        self.totalPages = try container.decode(Int.self, forKey: PageCollection<T>.CodingKeys.totalPages)
        self.totalResults = try container.decode(Int.self, forKey: PageCollection<T>.CodingKeys.totalResults)
    }
}
