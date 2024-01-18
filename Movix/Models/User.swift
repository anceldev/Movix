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
    var recomendations: [String]
    var history: [String: String] // [Type: Identifier]
    
    var image: String? {
        let collection = Collections.users
        guard let image = id else { return nil }
        return collection.rawValue + image
    }
    
    init(id: String? = nil, name: String = "", email: String = "", friends: [String] = [], recomendations: [String] = [], history: [String : String] = [:]) {
        self.id = id
        self.name = name
        self.email = email
        self.friends = friends
        self.recomendations = recomendations
        self.history = history
    }
}
