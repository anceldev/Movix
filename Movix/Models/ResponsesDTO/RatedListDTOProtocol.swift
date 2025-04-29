//
//  RatedListDTOProtocol.swift
//  Movix
//
//  Created by Ancel Dev account on 23/4/25.
//

import Foundation

protocol RatedListDTOProtocol: Decodable, Identifiable {
    var id: Int? { get set }
    var userId: UUID { get set }
    var media: SupabaseMedia { get set }
    var rate: Int? { get set }
}
