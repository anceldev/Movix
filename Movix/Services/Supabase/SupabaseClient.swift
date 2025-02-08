//
//  SupabaseClient.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import Foundation
import Supabase

enum SupabaseConfig {
    case projectUrl
    case anonKey
    
    var id: String {
        switch self {
        case .projectUrl: Bundle.main.infoDictionary?["ProjectUrl"] as! String
        case .anonKey: Bundle.main.infoDictionary?["AnonKey"] as! String
        }
    }
}

enum SupabaseTables: String {
    case listMovies = "list_movies"
    case favorites
    case list
    case ratings
    case users
}

enum SupabaseClientError: Error {
    case invalidAccount
}

final class SupClient {
    let client: SupabaseClient
    let auth: AuthClient
    
    static var shared = SupClient()
    
    init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: SupabaseConfig.projectUrl.id)!,
            supabaseKey: SupabaseConfig.anonKey.id
        )
        self.auth = self.client.auth
    }
    
    func signUp(email: String, password: String, lang: String? = nil) async throws -> Account {
        let authResponse = try await auth.signUp(
            email: email,
            password: password
        )
        guard let _ = authResponse.session else {
            throw SupabaseClientError.invalidAccount
        }
        
        let account = Account(id: authResponse.user.id, username: email, email: email, lang: lang)
        let _ = try await client.from(SupabaseTables.users.rawValue)
            .insert(account)
            .execute()
        return try await getAccount(userId: account.id)
    }
    
    func signUpWithMetadata(email: String, password: String, username: String?, lang: String?) async throws -> Account {
        var metadata: [String: AnyJSON] = [:]
        metadata["username"] = .string(username != nil ? username! : email)
        if let lang = lang {
            metadata["lang"] = .string(lang)
        }
        
        let authResponse = try await auth.signUp(
            email: email,
            password: password,
            data: metadata
        )
        guard let _ = authResponse.session else {
            throw SupabaseClientError.invalidAccount
        }
        return try await getAccount(userId: authResponse.user.id)
    }
    
    func signIn(email: String, password: String) async throws -> Account {
        try await auth.signIn(email: email, password: password)
        let user = try await auth.user()
        return try await getAccount(userId: user.id)
    }
    func signOut() async throws {
        try await auth.signOut()
    }
    func getCurrentUser() async throws -> Account {
        let user = try await auth.user()
        return try await getAccount(userId: user.id)
    }
    func updateUserMetadata(username: String?, lang: String?) async throws {
        var metadata: [String:AnyJSON] = [:]
        if let username = username {
            metadata["username"] = .string(username)
        }
        if let lang = lang {
            metadata["lang"] = .string(lang)
        }
        try await auth.update(user: UserAttributes(data: metadata))
    }
    
    private func getAccount(userId: UUID) async throws -> Account {
        let userData = try await client
            .from(SupabaseTables.users.rawValue)
            .select("""
                    *,
                    movies(*)
                    """)
            .eq("id", value: userId)
            .execute()
        return try JSONDecoder().decode([Account].self, from: userData.data)[0]
    }
}
