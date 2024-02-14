//
//  User.swift
//  Movix
//
//  Created by Ancel Dev account on 18/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var friends: [String]
    var history: [Int]
    var settings: Settings?
    
    init(id: String? = nil, name: String = "", email: String = "", friends: [String] = [], history: [Int] = [], settings: Settings? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.friends = friends
        self.history = history
        self.settings = settings
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
