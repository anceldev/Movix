//
//  Repositories.swift
//  Movix
//
//  Created by Ancel Dev account on 6/2/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift



final class RepositoriesManager {
    
    let reference = Firestore.firestore()

    func createUserDocument(_ user: User) async throws {
        guard let userID = user.id else {
            throw RepositoryErrors.nilUid
        }
        do {
            print(userID)
            try await reference.collection(usersCollection).document(userID).setData(from: user)
        }
        catch {
            print(error.localizedDescription)
            throw RepositoryErrors.failCreateDocument
        }
    }
    func fetchUserData(with uidUser: String) async throws -> User {
        do {
            let docReference = reference.collection(usersCollection).document(uidUser)
            let document = try await docReference.getDocument()
            let user = try document.data(as: User.self)
            return user
        }
        catch {
            print(error.localizedDescription)
            throw RepositoryErrors.noDocumentFound
        }
    }
    
}
enum RepositoryErrors: Error {
    case nilUid
    case failCreateDocument
    case noDocumentFound
    
    func errorMessage() -> String {
        switch self {
        case .nilUid:
            return "Nil id founded in User"
        case .failCreateDocument:
            return "Error creating user's document"
        case .noDocumentFound:
            return "User document not found"
        }
    }
}
extension RepositoriesManager {
    static let repositories = RepositoriesManager()
}
private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            // Method only throws if there’s an encoding error, which indicates a problem with our model.
            // We handled this with a force try, while all other errors are passed to the completion handler.
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}
