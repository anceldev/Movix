//
//  HTTPClient.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation

enum HTTPMethod {
    case get([URLQueryItem])
//    case post(Data?)
    case post(Data?,[URLQueryItem])
    case delete(Data?)
    
    var name: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        }
    }
}

struct Resource<T:Codable> {
    let url: URL
    var method: HTTPMethod = .get([])
    var modelType: T.Type
}

struct HTTPClient {
    
    static var shared = HTTPClient()
    private var defaultHeaders: [String: String] {
        var headers = ["accept": "application/json"]
        headers["content-type"] = "application/json"
        headers["Authorization"] = "Bearer \(Bundle.main.infoDictionary?["BearerToken"] as? String ?? "")"
        return headers
    }
    
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        var request = URLRequest(url: resource.url)
        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(
                url: resource.url,
                resolvingAgainstBaseURL: false
            )
            components?.queryItems = queryItems
            guard let url = components?.url else {
                throw NetworkError.badRequest
            }
            request = URLRequest(url: url)
            request.httpMethod = resource.method.name
            request.timeoutInterval = 10
            
            
        case .post(let data, let queries):
//            if queries.count > 0 {
//                var components = URLComponents(
//                    url: resource.url,
//                    resolvingAgainstBaseURL: false
//                )
//                components?.queryItems = queries
//                guard let url = components?.url else {
//                    throw NetworkError.badRequest
//                }
//                request = URLRequest(url: url)
//            }
            request.httpMethod = resource.method.name
            request.httpBody = data
        case .delete(let data):
            request.httpMethod = resource.method.name
            request.httpBody = data
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        let session = URLSession(configuration: configuration)
        let (data, response) = try await session.data(for: request)
//        print(String(decoding: data, as: UTF8.self))
        guard let _ = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        do {
            let result = try JSONDecoder().decode(resource.modelType, from: data)
            return result
        } catch {
            print(error)
            print(error.localizedDescription)
            throw NetworkError.decodingError
        }
    }
}
