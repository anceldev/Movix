//
//  MediaSupabaseProtocol.swift
//  Movix
//
//  Created by Ancel Dev account on 23/4/25.
//

import Foundation

protocol MediaSupabaseProtocol: Identifiable, Codable {
    var id: Int { get set }
    var posterPath: String? { get set }
}
