//
//  AuthenticationViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 24/10/23.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}
enum AuthenticationFlow {
    case login
    case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var account = Account(id: "", name: "", email: "", birthdate: Date(), typeSuscription: .noSpecified)
    private var dbUsers = Firestore.firestore().collection("users_v1")
    
    @Published var user: User?
    @Published var flow: AuthenticationFlow = .login
    
    @Published var isValid = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    @Published var displayName = ""
    
    
    
    init(){
        registerAuthStateHandler()
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle? // To persist the authentication state whe the app relaunches.
    
    func registerAuthStateHandler(){
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener({ auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? ""
            })
        }
    }
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
    func reset(){
        flow = .login
    }
}

// Manages Authentication
extension AuthenticationViewModel {
    func singInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: self.email, password: self.password)
            return true
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().createUser(withEmail: self.email, password: self.password)
            return true
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
            authenticationState = .unauthenticated
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
        
    }
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: ""){ error in
            print("We can't send you a reset link at the moment.")
            print(error!)
        }
    }
    
    func fetchUser(uidUser: String) {
        // Here we'll fetch the user with the users collection from firestore
    }
}

// Manages Users Firestore collection
extension AuthenticationViewModel {
    
    func createUserAccount(_ account: Account) {
        Task {
            do {
                try await createAccount(account)
            }
            catch {
                print(error)
                print("[AuthenticaitonViewModel] Error while creating new account.")
            }
        }
    }
    func fetchUserAccount(_ uidUser: String) {
        Task {
            do {
                let account = try await fetchAccount(uidUser)
                self.account = account
            }
            catch {
                print(error)
                print("[AuthenticationViewModel] Error while fetching user account")
            }
        }
    }
    
    private func createAccount(_ account: Account) async throws {
        let document = dbUsers.document(account.id)
        do{
            try await document.setData(from: account)
        }
        catch {
            print("[AuthenticationViewModel] Can't create user document.")
            throw AccountError.accountNotCreated
        }
    }
    private func fetchAccount(_ uidAccount: String) async throws -> Account {
        let document = dbUsers.document(uidAccount)
        do {
            let document = try await document.getDocument()
            let account = try document.data(as: Account.self)
            return account
        }
        catch {
            print("[AuthenticationViewModel] Can't fetch user document.")
            throw AccountError.accountNotFound
        }
    }
    enum AccountError: Error {
        case accountNotFound
        case accountNotCreated
    }
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
