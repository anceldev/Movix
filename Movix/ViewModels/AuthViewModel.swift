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
enum AuthFlow {
    case signIn
    case signUp
}



@Observable
final class AuthViewModel {
    var email: String = ""
    var password: String = ""
    var username: String = ""
    
    var user: Account?

    var errorMessage: String? = nil
    
    var flow: AuthFlow = .signIn
    var state: AuthState = .unauthenticated
    
    init() {
        Task {
            await checkAuthentication()
        }
    }
    
    func checkAuthentication() async {
        do {
            self.state = .authenticating
            self.user = try await SupClient.shared.getCurrentUser()
            self.state = .authenticated
        } catch {
            handleError(error)
            self.state = .unauthenticated
        }
    }
    func signIn() async {
        do {
            self.state = .authenticating
            self.user = try await SupClient.shared.signIn(email: email, password: password)
            self.state = .authenticated
        } catch {
            handleError(error)
            self.state = .unauthenticated
        }
    }
    func signUp() async {
        do {
            self.state = .authenticating
            self.user = try await SupClient.shared.signUp(email: email, password: password)
            self.state = .authenticated
        } catch {
            handleError(error)
            self.state = .unauthenticated
        }
    }
    func signOut() async {
        do {
            self.state = .authenticating
            try await SupClient.shared.signOut()
            self.state = .unauthenticated
        } catch {
            handleError(error)
            self.state = .unauthenticated
        }
    }
    private func handleError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
}
