//
//  HTTPClient.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation

enum HTTPMethod {
    case get([URLQueryItem])
    case post(Data?)
    case delete
    
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
//struct HTTPClient {
//    static var shared = HTTPClient()
//    private let session: URLSession
//    
//    init() {
//        let configuration = URLSessionConfiguration.default
//        configuration.httpMaximumConnectionsPerHost = 4
////        configuration.timeoutInterval = 10
//        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
//        configuration.urlCache = nil
//        configuration.httpAdditionalHeaders = [
//            "accept": "application/json",
//            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YmQ3MWQzMzJjM2QzYzIxOWZlMDFjOGQ0NjViYTAzYSIsInN1YiI6IjY0YTkzNDliOWM5N2JkMDBlMjRiZDZiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.OpReI1L4z-tWgq3yQHC9v8jniJmheltoWRZZ9tJ0DkM"
//        ]
//        session = URLSession(configuration: configuration)
//    }
//    
//    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
//        var request = URLRequest(url: resource.url)
//        request.timeoutInterval = 10
//        
//        switch resource.method {
//        case .get(let queryItems):
//            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
//            components?.queryItems = queryItems
//            guard let url = components?.url else { throw NetworkError.badRequest }
//            request = URLRequest(url: url)
//        case .post(let data):
//            request.httpBody = data
//        case .delete:
//            break
//        }
//        
//        request.httpMethod = resource.method.name
//        
//        let (data, response) = try await session.data(for: request)
//        guard let _ = response as? HTTPURLResponse else {
//            throw NetworkError.invalidResponse
//        }
//        
//        do {
//            return try JSONDecoder().decode(resource.modelType, from: data)
//        } catch {
//            print(error)
//            print(error.localizedDescription)
//            throw NetworkError.decodingError
//        }
//    }
//}

struct HTTPClient {
    
    static var shared = HTTPClient()
    
    private var defaultHeaders: [String: String] {
        var headers = ["accept": "application/json"]
        headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YmQ3MWQzMzJjM2QzYzIxOWZlMDFjOGQ0NjViYTAzYSIsIm5iZiI6MTY4ODgxMDY1MS4wNjksInN1YiI6IjY0YTkzNDliOWM5N2JkMDBlMjRiZDZiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.OpReI1L4z-tWgq3yQHC9v8jniJmheltoWRZZ9tJ0DkM"
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
            
            
        case .post(let data):
            request.httpMethod = resource.method.name
            request.httpBody = data
        case .delete:
            request.httpMethod = resource.method.name
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        let session = URLSession(configuration: configuration)
        let (data, response) = try await session.data(for: request)
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
