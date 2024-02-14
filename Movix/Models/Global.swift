//
//  Collections.swift
//  Movix
//
//  Created by Ancel Dev account on 18/1/24.
//

import Foundation

// Api key
//let api_key = ProcessInfo.processInfo.environment["TMDB_API_KEY"]
let api_key = "api_key=4bd71d332c3d3c219fe01c8d465ba03a"
let baseUrl = "https://api.themoviedb.org/3/"

// Firebase collections
enum Collections: String {
    case users = "users_v1.1"
    case movies = "movies_v 1.1"
    case usersPhotos = "usersProfilePhotos/"
}
let usersCollection = "users_v1.1"
let moviesCollection = "movies_v1.1"
let usersStorageBucket = "usersProfilePhotos/"

/// Available languages
enum Lan: String {
    case en = "en-US"
    case es = "es-ES"
    
    var query: String {
        "&language=" + self.rawValue
    }
}
// Main language for tests
extension Lan {
    static var mainLan = Lan.en
}


