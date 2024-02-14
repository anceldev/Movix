//
//  Errors.swift
//  Movix
//
//  Created by Ancel Dev account on 13/2/24.
//

import Foundation

// App errors
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

enum ServiceErrors: Error {
    case wrongURL
    case failedResponse
    case noMatchModel
    case notInitialized
    case mediaService
    case movieNotFound
    
    func errorMessage() -> String {
        switch self {
        case .wrongURL:
            return "The URL provided is wrong"
        case .failedResponse:
            return "Failed response from API"
        case .noMatchModel:
            return "The response model doesn't match with provided model"
        case .notInitialized:
            return "Model not initialized"
        case .mediaService:
            return "Error in media Service"
        case .movieNotFound:
            return "No movie founded for id"
        }
    }
}
