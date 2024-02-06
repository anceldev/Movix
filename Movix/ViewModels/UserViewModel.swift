//
//  AccountViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 27/10/23.
//

import Foundation
import SwiftUI
import FirebaseStorage
import Observation

@Observable
class UserViewModel {
    var user: User
    var profileImage: Image
    private let bucket = usersStorageBucket
    private let storage = Storage.storage()
    
    init(uidUser: String) {
        self.user = User()
        self.profileImage = Image("avatarDefault")
        fetchUser(uidUser: uidUser)
        if let idUser = self.user.id {
            downloadAvatar(uidUser: idUser) { image in
                if let uiImage = image {
                    self.profileImage = Image(uiImage: uiImage)
                } else {
                    
                    print("Cant use image")
                }
            }
        }
    }
    private func fetchUser(uidUser: String) {
        Task {
            do {
                self.user = try await RepositoriesManager.repositories.fetchUserData(with: uidUser)
            }
            catch {
                fatalError("Cannot get user")
            }
        }
    }
    
    private func downloadAvatar(uidUser: String, completion: @escaping (UIImage?) -> Void) {
        let namePath = bucket + uidUser
        let maxSize: Int64 = 1 * 1024 * 1024
        let pathReference = storage.reference(withPath: namePath)
        
        pathReference.getData(maxSize: maxSize) { data, error in
            if let error = error {
                print("User diesn't has image: \(error.localizedDescription)")
            }
            else {
                if let data = data, let image = UIImage(data: data) {
                    print("Image downloaded")
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func updateAvatar(image: UIImage, uidUser: String) -> Bool {
        let refImage = bucket + uidUser
        let storageRef = storage.reference().child(refImage)
        let resizedImage = image.aspectFittedToHeight(300)
        let data = resizedImage.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let data = data {
            storageRef.putData(data, metadata: metadata) { metadata, error in
                if let error = error {
                    fatalError("Error while uploading file: \(error.localizedDescription)")
                }
                if let metadata = metadata {
                    print("Metadata: \(metadata)")
                }
                else {
                    fatalError("Wrong metadata")
                }
            }
        }
        return true
    }
}
/**
 Extension used to compress and resize image
 */
extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { image in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
//@MainActor
//class AccountViewModel: ObservableObject{
    /*@Published var account: Account
    // private let accountsRepository: AccountsRepositoryProtocol
    
    private var db = Firestore.firestore().collection("users_v1")
    
    init(newUser: Account){
        self.account = newUser
    }
    init(){
        account = Account(id: "", name: "", email: "", birthdate: Date(), friends: [], typeSuscription: .noSpecified)
    }*/
    
    /*func fetchUserAccount(_ uidUser: String){
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
    }*/
    /*func createUserAccount(_ account: Account) {
        Task {
            do {
                try await createAccount(account)
            }
            catch {
                print("[AccountViewModel] Error creating new account")
            }
        }
    }*/
    
    /*private func createAccount(_ account: Account) async throws {
        let document = db.document(account.id)
        do {
            try await document.setData(from: account)
        }
        catch {
            print("[AccountViewModel] Can't create user document")
            throw AccountError.accountNotCreated
        }
    }*/
    
    /*private func fetchAccount(_ uidAccount: String) async throws -> Account {
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
    }*/
//}
// FirestoreSwift need to be updated to support async/await, thats why we add this extension.
/*private extension DocumentReference {
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
}*/
