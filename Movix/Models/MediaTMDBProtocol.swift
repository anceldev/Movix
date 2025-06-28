//
//  MediaTMDBProtocol.swift
//  Movix
//
//  Created by Ancel Dev account on 27/2/25.
//

import Foundation

protocol MediaTMDBProtocol: Identifiable {
    var id: Int { get set }
    var backdropPath: String? { get set }
    var genres: [Genre]? { get set }
    var homepage: URL? { get set }
    var originCountry: [String] { get set }
    var posterPath: String? { get set }
    var releaseDate: Date? { get set }
    var status: String? { get set }
    var title: String { get set }
    var voteAverage: Double? { get set }
}
