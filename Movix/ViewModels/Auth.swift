//
//  Auth.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation
import Supabase
import SwiftUI

enum AuthState {
    case authenticated
    case authenticating
//    case preferences
    case unauthenticated
}

enum RequestError: Error {
    case logoutError
    case tokenError
    case tokenValidationError
    case sessionError
    case failedRequest
    case listError
}

enum AuthenticationError: Error {
    case userNotInserted
    case userNotFound
}

enum AuthFlow {
    case signIn
    case signUp
    case preferences
    
    var localizedTitle: String {
        switch self {
        case .signIn:
            NSLocalizedString("login-signin-title", comment: "Sign in")
        case .signUp:
            NSLocalizedString("login-signup-title", comment: "Sign up")
        case .preferences:
            NSLocalizedString("signup-profile-title", comment: "Perfil")
        }
    }
}

@Observable
final class Auth {
    
    typealias Client = MovixClient
    let supabase = Client.shared.supabase
    
    var username = ""
    var email = ""
    var password = ""
    var language = ""
    var country = ""
    
    var user: User?
    
    var state: AuthState = .unauthenticated
    var flow: AuthFlow = .signIn

    private var httpClient = HTTPClient()
    
    var errorMessage: String? = nil
    
    init() {
        Task {
            await checkAuthState()
        }
    }
    
    private func checkAuthState() async {
        state = .authenticating
        do {
            let session = try await supabase.auth.session
            user = try await getUser(userId: session.user.id)
            setUserSettings(user!)
            state = .authenticated
        } catch {
            state = .unauthenticated
        }
    }
    
    func signUp(email: String, password: String) async -> AuthState {
        defer { resetValues() }
        state = .authenticating
        do {
            self.user = try await signUpUser(email: email, password: password)
            setUserSettings(user!)
            self.username = (user?.email.components(separatedBy: "@").first)!
            return .authenticated
        } catch {
            setError(error)
            state = .unauthenticated
            return .unauthenticated
        }
    }
//    func signIn() async {
//        defer { resetValues() }
//        state = .authenticating
//        do {
//            self.user = try await signInUser()
//            setUserSettings(user!)
//            state = .authenticated
//        } catch {
//            setError(error)
//            state = .unauthenticated
//        }
//    }
    func signIn(email: String, password: String) async -> AuthState{
        defer { resetValues() }
        state = .authenticating
        do {
            self.user = try await signInUser(email: email, password: password)
            setUserSettings(user!)
            state = .authenticated
            return .authenticated
        } catch {
            setError(error)
            state = .unauthenticated
            return .unauthenticated
        }
    }
    
//    func signIntWithTokeb(idToken: String, userId: String, provider: OpenIDConnectCredentials.Provider) async {
//        do {
//            let authResponse = try await supabase.auth.signInWithIdToken(
//                credentials: .init(
//                    provider: provider,
//                    idToken: idToken
//                )
//            )
//            let authUser = authResponse.user
//            print("Succesfully signed in user: \(user!.id)")
//            
//            
//        } catch {
//            setError(error)
//        }
//    }
    
    func setUserPreferences(avatarImage: UIImage?, lang: String?, country: String?) async {
        defer { resetValues() }
        do {
            var newData: [String:String?] = ["username":self.username]

            if let avatarImage {
                let (path, imageData) = try await MovixClient.shared.updateAvatar(userId: user!.id, uiImage: avatarImage)
                user?.avatarPath = path
                user?.avatarData = imageData
                newData["avatar_path"] = path
            }
            if let lang { newData["lang"] = lang }
            if let country { newData["country"] = country }
            
            let _ = try await supabase
                .from("users")
                .update(newData)
                .eq("id", value: "\(user!.id.uuidString)")
                .execute()
            
            state = .authenticated
        } catch {
            setError(error)
        }
    }
    func updateProfile(avatar: UIImage?, username: String, lang: String?, country: String?) async -> AuthState {
        defer { resetValues() }
        do {
            var newData: [String:String?] = [:]
            if(username != "") {
                newData["username"] = username
            }

            if let avatar {
                let (path, imageData) = try await MovixClient.shared.updateAvatar(userId: user!.id, uiImage: avatar)
                user?.avatarPath = path
                user?.avatarData = imageData
                newData["avatar_path"] = path
            }
            if let lang { newData["lang"] = lang }
            if let country { newData["country"] = country }
            
            let _ = try await supabase
                .from("users")
                .update(newData)
                .eq("id", value: "\(user!.id.uuidString)")
                .execute()
            
            state = .authenticated
            return .authenticated
        } catch {
            setError(error)
            return .authenticated
        }
    }
    
    private func signInUser(email: String, password: String) async throws -> User {
        let session = try await supabase.auth.signIn(
            email: email,
            password: password
        )
        return try await getUser(userId: session.user.id)
    }
    
//    private func signInUser() async throws -> User {
//        let session = try await supabase.auth.signIn(
//            email: self.email,
//            password: self.password
//        )
//        return try await getUser(userId: session.user.id)
//    }
//    private func signUpUser() async throws -> User {
//        let session = try await supabase.auth.signUp(
//            email: self.email,
//            password: self.password
//        )
//        return try await getUser(userId: session.user.id)
//    }
    private func signUpUser(email: String, password: String) async throws -> User {
        let session = try await supabase.auth.signUp(
            email: email,
            password: password
        )
        return try await getUser(userId: session.user.id)
    }
    private func setUserSettings(_ user: User) {
        UserDefaults.standard.set(user.country, forKey: "country")
        UserDefaults.standard.set(user.lang, forKey: "lang")
    }
    
    private func getUser(userId: UUID) async throws -> User {
        try await supabase
            .from("users")
            .select("*")
            .eq("id", value: userId)
            .single()
            .execute()
            .value
    }
    
    func signOut() async {
        defer { resetValues() }
        state = .authenticating
        do {
            try await supabase.auth.signOut()
            self.user = nil
            state = .unauthenticated
        } catch {
            setError(error)
        }
    }
    
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
    
    private func resetValues() {
        username = ""
        email = ""
        password = ""
        language = "en"
        country = "US"
        errorMessage = nil
    }
}
