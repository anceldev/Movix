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
    case sessionError
    case failedRequest
}

@Observable
final class AuthViewModel {
    var username: String = "anceltests"
    var password: String = "12121212"
    
    var user: User?
    var state: AuthState = .unauthenticated
    private var tmdbSession: String = ""
    private var httpClient = HTTPClient()
    
    var errorMessage: String? = nil
    
    init() {
        guard let currentSessionId = UserDefaults.standard.string(forKey: "session_id") else {
            self.state = .unauthenticated
            return
        }
        Task {
            do {
                self.tmdbSession = currentSessionId
                self.user = try await getAccount()
                self.state = .authenticated
            } catch {
                setError(error)
                self.state = .unauthenticated
            }
        }
    }
    
    func signIn() async {
        self.state = .authenticating
        do {
            let token = try await requestToken()
            let sessionToken = try await validateTokenWithLogin(token: token)
            let sessionId = try await createSession(token: sessionToken)
            self.tmdbSession = sessionId
            UserDefaults.standard.set(sessionId, forKey: "session_id")
            print(sessionId)
            let user = try await getAccount()
            self.user = user
            self.state = .authenticated
            
        } catch {
            setError(error)
            self.state = .unauthenticated
        }
    }
    
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
    
    /// Validates a requested token
    /// - Parameter token: token to validate
    /// - Returns: validated token
    private func validateTokenWithLogin(token: String) async throws -> String {
        let parameters = [
            "username": self.username,
            "password": self.password,
            "request_token": token,
        ] as [String:Any]
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        let resourceValidation = Resource(
            url: Endpoints.validateTokenWithLogin.url,
            method: .post(postData, []),
            modelType: Response.self
        )
        let responseValidation = try await httpClient.load(resourceValidation)
        guard let success = responseValidation.success,
                success == true,
                let sessionToken = responseValidation.token else {
            throw RequestError.sessionError
        }
        return sessionToken
    }
    
    /// Requests a token for authentication
    /// - Returns: token
    private func requestToken() async throws -> String {
        let resource = Resource(
            url: Endpoints.requestToken.url,
            modelType: Response.self
        )
        let response = try await httpClient.load(resource)
        guard let succes = response.success, succes == true, let token = response.token else {
            throw RequestError.tokenError
        }
        return token
    }
    
    /// Creates a session with the requested and validated token
    /// - Parameter token: validated token
    /// - Returns: session token
    private func createSession(token: String) async throws -> String{
        let parameters = [ "request_token": token] as [String:Any?]
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        let resource = Resource(
            url: Endpoints.createSession.url,
            method: .post(postData, []),
            modelType: Response.self
        )
        let session = try await httpClient.load(resource)
        guard let succes = session.success,
                succes == true,
                let sessionId = session.sessionId else {
            throw RequestError.sessionError
        }
        return sessionId
    }
    
    private func getAccount() async throws -> User {
        print(tmdbSession)
        let resource = Resource(
            url: Endpoints.getAccount(self.tmdbSession).url,
            modelType: User.self
        )
        let user = try await httpClient.load(resource)
        return user
    }
    
    func signOut() async {
        do {
            let data = [ "session_id": self.tmdbSession ] as [String:Any]
            let postData = try JSONSerialization.data(withJSONObject: data, options: [])
            
            let resource = Resource(
                url: Endpoints.deleteSession.url,
                method: .delete(postData),
                modelType: Response.self
            )
            let response = try await httpClient.load(resource)
            if let succes = response.success, succes == true {
                resetValues()
            }
            else {
                throw RequestError.logoutError
            }
        } catch {
            setError(error)
        }
    }
    private func resetValues() {
        self.tmdbSession = ""
        self.user = nil
        self.state = .unauthenticated
        self.username = ""
        self.password = ""
        UserDefaults.standard.removeObject(forKey: "session_id")
    }
}
