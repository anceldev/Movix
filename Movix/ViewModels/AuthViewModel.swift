//
//  AuthViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation

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

@Observable
final class AuthViewModel {
    var username: String = ""
    var password: String = ""
    
    var user: User?
    var state: AuthState = .authenticating
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
            let token = try await createRequestToken()
            try await validateTokenWithLogin(with: token)
            let sessionId = try await createSession(token: token)
            self.tmdbSession = sessionId
            UserDefaults.standard.set(sessionId, forKey: "session_id")
            let user = try await getAccount()
            self.user = user
            UserDefaults.standard.set(user.lang, forKey: "lang")
            UserDefaults.standard.set(user.country, forKey: "country")
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
    
    /// Requests a token for authentication
    /// - Returns: token
    private func createRequestToken() async throws -> String {
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
    private func validateTokenWithLogin(with token: String) async throws {
        let parameters = [
            "username": self.username,
            "password": self.password,
            "request_token": token,
        ] as [String:Any]
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        let resourceValidation = Resource(
            url: URL(string: Endpoints.validateTokenWithLogin.url.absoluteString)!,
            method: .post(postData, []),
            modelType: Response.self
        )
        let responseValidation = try await httpClient.load(resourceValidation)
        guard let success = responseValidation.success,
              success == true,
              let _ = responseValidation.token else {
            throw RequestError.tokenValidationError
        }
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
//        let resource = Resource(
//            url: Endpoints.getAccount("\(self.tmdbSession)").url,
//            modelType: User.self
//        )
//        let user = try await httpClient.load(resource)
//        return user
        let url = Endpoints.getAccount("\(self.tmdbSession)").url
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            print(String(decoding: data, as: UTF8.self))
            let user = try decoder.decode(User.self, from: data)
            return user
        } catch {
            print(error.localizedDescription)
            throw error
        }
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
