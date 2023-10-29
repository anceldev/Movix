//
//  AuthenticationViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 24/10/23.
//

import FirebaseAuth
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

