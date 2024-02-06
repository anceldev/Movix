//
//  UsersRepository.swift
//  Movix
//
//  Created by Ancel Dev account on 27/10/23.
//


import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

protocol AccountsRepositoryProtocol {
    static func createAccount(_ account: User) async throws
    static func fetchAccount(_ uidAccount: String) async throws -> User
}


// Repository created to manage users information
struct AccountsRepository: AccountsRepositoryProtocol {
    
    static let usersReference = Firestore.firestore().collection("users")
    
    // Creates a new account
    static func createAccount(_ account: User) async throws {
        let document = usersReference.document(account.id!)
        do{
            try await document.setData(from: account)
        }
        catch {
            print("[AccountsRepository] Can't create user document")
        }
    }
    // Loads an existing account.
    static func fetchAccount(_ uidAccount: String) async throws -> User {
        let docReference = usersReference.document(uidAccount) // Accound document reference
        
        do {
            let document = try await docReference.getDocument()
            let account = try document.data(as: User.self)
            return account
        }
        catch {
            print("[AccountsRepository] Can't fetche user document")
            throw AccountError.accountNotFound
        }
    }
    enum AccountError: Error {
        case accountNotFound
    }
}
// FirestoreSwift need to be updated to support async/await, thats why we add this extension.
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
