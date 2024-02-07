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
enum AppErrors: Error {
    case nilUid
    case failCreateDocument
    case noDocumentFound
    case changeRequestError
    
    func errorMessage() -> String {
        switch self {
        case .nilUid:
            return "Nil id founded in User"
        case .failCreateDocument:
            return "Error creating user's document"
        case .noDocumentFound:
            return "User document not found"
        case .changeRequestError:
            return "Cannot create profileChangeRequest from specified user"
        }
    }
}
