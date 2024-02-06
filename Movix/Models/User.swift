//
//  User.swift
//  Movix
//
//  Created by Ancel Dev account on 18/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var friends: [String]
    var settings: Settings
    var history: [Int] // [Type: Identifier]
    
    var image: String? {
        let collection = Collections.users
        guard let image = id else { return nil }
        return collection.rawValue + image
    }
}

struct Settings: Codable {
    var movieRecomendations: [Genre]
    var tvshowRecomendations: [Genre]
    var notifications: Bool
    
    init(movieRecomendations: [Genre] = [], tvshowRecomendations: [Genre] = [], notifications: Bool = false) {
        self.movieRecomendations = movieRecomendations
        self.tvshowRecomendations = tvshowRecomendations
        self.notifications = notifications
    }
}
