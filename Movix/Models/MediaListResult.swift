//
//  MediaListResult.swift
//  Movix
//
//  Created by Ancel Dev account on 12/2/24.
//

import Foundation


struct MediaListResult<Result>: Encodable, Decodable where Result: Codable, Result: Identifiable {
    let page: Int?
    let results: [Result]
    let totalPages: Int?
    let totalResults: Int?
    
    init(page: Int? = nil, results: [Result] = [], totalPages: Int? = nil, totalResults: Int? = nil) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
