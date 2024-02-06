//
//  Collections.swift
//  Movix
//
//  Created by Ancel Dev account on 18/1/24.
//

import Foundation

let usersCollection = "users_v1.1"
let moviesCollection = "movies_v1.1"
let usersStorageBucket = "usersProfilePhotos/"
/// Main language for queries
enum Lan: String {
    case en = "en-US"
    case es = "es-ES"
}
extension Lan {
    static var mainLan = Lan.en
}
