//
//  AuthViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation
import Supabase

enum AuthState {
    case authenticated
    case authenticating
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
    
    private var tmdbSession: String = ""
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
            let authSession = try await supabase.auth.signUp(
                email: email,
                password: password
            )
            
            let user = User(
                id: authSession.user.id,
                name: nil,
                username: username,
                email: email,
                lang: language,
                country: country,
                avatarPath: nil
            )
            
            let response = try await supabase
                .from(SupabaseTables.users.rawValue)
                .insert(user)
                .execute()
            
            if response.status == 201 {
                self.user = user
                state = .authenticated
                return
            }
            throw AuthenticationError.userNotInserted
        } catch {
            setError(error)
            state = .unauthenticated
        }
    }
    
    func signIn() async {
        defer { resetValues() }
        state = .authenticating
        do {
            let authSession = try await supabase.auth.signIn(email: email, password: password)
            user = try await getUser(userId: authSession.user.id)
            state = .authenticated
        } catch {
            setError(error)
            state = .unauthenticated
        }
    }
    
    private func getUser(userId: UUID) async throws -> User {
        do {
            let response = try await supabase
                .from(SupabaseTables.users.rawValue)
                .select("*")
                .eq("id", value: userId)
                .execute()
            return try JSONDecoder().decode([User].self, from: response.data)[0]
        } catch {
            throw error
        }
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
