//
//  UserFetchingData.swift
//  Movix
//
//  Created by Ancel Dev account on 1/11/23.
//

import Foundation

@MainActor
final class UserFetchingData: ObservableObject {
    
}
extension UserFetchingData {
    static func fetchData<T: Codable>(forItem item: T, withUrl urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            print("[UserFetchingData] Can't generate URL from string provided.")
            throw UFDError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("[UserFetchingData] Response code failed.")
            throw UFDError.reponseFailed
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print("[UserFetchingData] Data model doesn't match.")
            throw UFDError.modelNotMatch
        }
    }
}
enum UFDError: Error {
    case invalidURL
    case reponseFailed
    case modelNotMatch
    case notInitialized
}
