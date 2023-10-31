//
//  AccountViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 27/10/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class AccountViewModel: ObservableObject{
    @Published var account: Account
    // private let accountsRepository: AccountsRepositoryProtocol
    
    private var db = Firestore.firestore().collection("users_v1")
    
    init(newUser: Account){
        self.account = newUser
    }
    init(){
        account = Account(id: "", name: "", email: "", birthdate: Date(), friends: [], typeSuscription: .noSpecified)
    }
    
    func fetchUserAccount(_ uidUser: String){
        Task {
            do {
                let account = try await fetchAccount(uidUser)
                self.account = account
            }
            catch {
                print("cant fetch user")
                throw error
            }
        }
    }
    func createUserAccount(_ account: Account) {
        Task {
            do {
                try await createAccount(account)
            }
            catch {
                print("[AccountViewModel] Error creating new account")
            }
        }
    }
    
    private func createAccount(_ account: Account) async throws {
        let document = db.document(account.id)
        do {
            try await document.setData(from: account)
        }
        catch {
            print("[AccountViewModel] Can't create user document")
            throw AccountError.accountNotCreated
        }
    }
    
    private func fetchAccount(_ uidAccount: String) async throws -> Account {
        let document = db.document(uidAccount)
        do{
            let document = try await document.getDocument()
            let account = try document.data(as: Account.self)
            return account
        }
        catch {
            print("[AccountrViewModel] Can't fetch user document")
            throw AccountError.accountNotFound
        }
    }
    
    
    enum AccountError: Error {
        case accountNotFound
        case accountNotCreated
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
