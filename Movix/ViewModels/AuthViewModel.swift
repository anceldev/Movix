//
//  AuthViewModel.swift
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
    case preferences
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
}

@Observable
final class AuthViewModel {
    
    typealias Client = SupClient
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
            await getCurrentSession()
        }
    }
    
    private func getCurrentSession() async {
        state = .authenticating
        do {
            let session = try await supabase.auth.session
            user = try await getUser(userId: session.user.id)
            setUserSettings(user!)
            state = .authenticated
        } catch {
            print(error)
            print(error.localizedDescription)
            state = .unauthenticated
        }
    }
    
    func signUp() async {
        defer { resetValues() }
        state = .authenticating
        do {
            self.user = try await signUpUser()
            setUserSettings(user!)
            self.username = (user?.email.components(separatedBy: "@").first)!
            state = .preferences
        } catch {
            setError(error)
            state = .unauthenticated
        }
    }
    func signIn() async {
        defer { resetValues() }
        state = .authenticating
        do {
            self.user = try await signInUser()
            setUserSettings(user!)
            state = .authenticated
        } catch {
            setError(error)
            state = .unauthenticated
        }
    }
    
    func setUserPreferences(avatarImage: UIImage?, lang: String?, country: String?) async {
        defer { resetValues() }
        do {
            var newData: [String:String?] = ["username":self.username]

            if let avatarImage {
                let (path, imageData) = try await SupClient.shared.uploadAvatar(userId: user!.id, uiImage: avatarImage)
                user?.avatarPath = path
                user?.avatarData = imageData
                newData["avatar_path"] = path
            }
            if let lang { newData["lang"] = lang }
            if let country { newData["country"] = country }
            
            print(newData)
            
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
    
    private func signInUser() async throws -> User {
        let session = try await supabase.auth.signIn(
            email: self.email,
            password: self.password
        )
        return try await getUser(userId: session.user.id)
    }
    private func signUpUser() async throws -> User {
        let session = try await supabase.auth.signUp(
            email: self.email,
            password: self.password
        )
        return try await getUser(userId: session.user.id)
    }
    private func setUserSettings(_ user: User) {
        UserDefaults.standard.set(user.country, forKey: "country")
        UserDefaults.standard.set(user.lang, forKey: "lang")
    }
    
    func setUserLanguage(lang: String?) async {
        guard let lang = lang, user != nil else { return }
        do {
            let _ = try await supabase
                .from("users")
                .update(["lang": lang])
                .eq("id", value: user!.id)
                .execute()
            user?.lang = lang
        } catch {
            setError(error)
        }
    }
    func setUserCountry(country: String?) async {
        guard let country = country, user != nil else { return }
        do {
            let _ = try await supabase
                .from("users")
                .update(["country": country])
                .eq("id", value: user!.id)
                .execute()
            user?.country = country
        } catch {
            setError(error)
        }
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
    
    private func resetValues() {
        username = ""
        email = ""
        password = ""
        language = "en"
        country = "US"
        errorMessage = nil
    }
    
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
}
