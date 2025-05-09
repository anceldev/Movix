//
//  AuthService.swift
//  Movix
//
//  Created by Ancel Dev account on 24/4/25.
//

import Foundation
import Observation

//// MARK: - Auth Service Protocol
//protocol AuthServiceProtocol {
//    var currentUser: User? { get }
//    var isAuthenticated: Bool { get }
//    
//    func signIn(email: String, password: String) async throws -> User
//    func signUp(email: String, password: String) async throws -> User
//    func signOut() async throws
//    func resetPassword(email: String) async throws
//    func deleteAccount() async throws
//}
//
//// MARK: - Auth Service Implementation
//final class AuthService: AuthServiceProtocol, ObservableObject {
//    @Published private(set) var currentUser: User?
//    
//    private let supabase: SupabaseClient
//    
//    var isAuthenticated: Bool {
//        currentUser != nil
//    }
//    
//    init(supabase: SupabaseClient = SupabaseClient.shared) {
//        self.supabase = supabase
//        setupAuthStateListener()
//    }
//    
//    // MARK: - Public Methods
//    func signIn(email: String, password: String) async throws -> User {
//        do {
//            let authResponse = try await supabase.auth.signIn(
//                email: email,
//                password: password
//            )
//            let user = try await fetchUserProfile(userId: authResponse.user.id)
//            await MainActor.run {
//                self.currentUser = user
//            }
//            return user
//        } catch {
//            throw AuthError.signInFailed(error.localizedDescription)
//        }
//    }
//    
//    func signUp(email: String, password: String) async throws -> User {
//        do {
//            let authResponse = try await supabase.auth.signUp(
//                email: email,
//                password: password
//            )
//            let user = try await createUserProfile(authUser: authResponse.user)
//            await MainActor.run {
//                self.currentUser = user
//            }
//            return user
//        } catch {
//            throw AuthError.signUpFailed(error.localizedDescription)
//        }
//    }
//    
//    func signOut() async throws {
//        do {
//            try await supabase.auth.signOut()
//            await MainActor.run {
//                self.currentUser = nil
//            }
//        } catch {
//            throw AuthError.signOutFailed(error.localizedDescription)
//        }
//    }
//    
//    func resetPassword(email: String) async throws {
//        do {
//            try await supabase.auth.resetPasswordForEmail(email)
//        } catch {
//            throw AuthError.resetPasswordFailed(error.localizedDescription)
//        }
//    }
//    
//    func deleteAccount() async throws {
//        guard let userId = currentUser?.id else {
//            throw AuthError.userNotFound
//        }
//        
//        do {
//            try await supabase
//                .from("users")
//                .delete()
//                .eq("id", value: userId)
//                .execute()
//            
//            try await signOut()
//        } catch {
//            throw AuthError.deleteAccountFailed(error.localizedDescription)
//        }
//    }
//    
//    // MARK: - Private Methods
//    private func setupAuthStateListener() {
//        Task {
//            for await update in supabase.auth.authStateChanges {
//                switch update.event {
//                case .signedIn:
//                    if let authUser = update.session?.user {
//                        let user = try? await fetchUserProfile(userId: authUser.id)
//                        await MainActor.run {
//                            self.currentUser = user
//                        }
//                    }
//                case .signedOut:
//                    await MainActor.run {
//                        self.currentUser = nil
//                    }
//                default:
//                    break
//                }
//            }
//        }
//    }
//    
//    private func fetchUserProfile(userId: UUID) async throws -> User {
//        let userProfile: User = try await supabase
//            .from("users")
//            .select()
//            .eq("id", value: userId)
//            .single()
//            .execute()
//            .value
//        
//        return userProfile
//    }
//    
//    private func createUserProfile(authUser: AuthUser) async throws -> User {
//        let userProfile = User(
//            id: authUser.id,
//            email: authUser.email,
//            username: nil,
//            avatarPath: nil
//        )
//        
//        try await supabase
//            .from("users")
//            .insert(userProfile)
//            .execute()
//        
//        return User(profile: userProfile)
//    }
//}

// MARK: - Auth Errors
enum AuthError: LocalizedError {
    case signInFailed(String)
    case signUpFailed(String)
    case signOutFailed(String)
    case resetPasswordFailed(String)
    case deleteAccountFailed(String)
    case userNotFound
    case avatarFileURLNotFound
    
    var errorDescription: String? {
        switch self {
        case .signInFailed(let message):
            return "Sign in failed: \(message)"
        case .signUpFailed(let message):
            return "Sign up failed: \(message)"
        case .signOutFailed(let message):
            return "Sign out failed: \(message)"
        case .resetPasswordFailed(let message):
            return "Reset password failed: \(message)"
        case .deleteAccountFailed(let message):
            return "Delete account failed: \(message)"
        case .userNotFound:
            return "User not found"
        case .avatarFileURLNotFound:
            return "Avatar file URL cannot be found"
        }
    }
}
