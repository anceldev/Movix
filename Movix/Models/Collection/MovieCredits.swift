//
//  MovieCredits.swift
//  Movix
//
//  Created by Ancel Dev account on 26/2/25.
//

import Foundation
//
struct MovieCredits: Identifiable, Codable {
    let id: Int
    let cast: [Movie]
}
