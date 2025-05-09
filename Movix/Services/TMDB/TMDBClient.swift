//
//  TMDBClient.swift
//  Movix
//
//  Created by Ancel Dev account on 16/4/25.
//

import Foundation
import Observation

final class TMDBService {
    
    static let shared = TMDBService()
    
    var countries = [Country]()
    var languages = [Language]()
    
    private init(){}
    
    func getCountries(lang: String, country: String) async throws -> [Country] {
        do {
            let langCountries = "\(lang)-\(country)"
            let resource = Resource(
                url: ConfigEndpoints.countries.url,
                method: .get([URLQueryItem(name: "language", value: langCountries)]),
                modelType: [Country].self
            )
            
            let response = try await HTTPClient.shared.load(resource)
            self.countries = response
            return response
        } catch {
            throw error
        }
    }
    
    func getLanguages(lang: String) async throws -> [Language] {
        do {
            let resource = Resource(
                url: ConfigEndpoints.languages.url,
                method: .get([URLQueryItem(name: "language", value: lang)]),
                modelType: [Language].self
            )
            let response = try await HTTPClient.shared.load(resource)
            self.languages = response
            return response
        } catch {
            throw error
        }
    }
}
