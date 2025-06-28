//
//  CatalogViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 16/5/25.
//

import Foundation
import Observation

@Observable
final class CatalogViewModel {
    var movieGenres = [Genre]()
    var serieGenres = [Genre]()
    
    var errorMessage: String?

    private let lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
    private let httpClient = HTTPClient.shared
    
    init() {
        Task {
            await getMovieGenres()
            print(self.movieGenres.count)
            await getSerieGenres()
        }
    }
    
    
    private func getMovieGenres() async {
        do {
            let resource = Resource(
                url: MovieEndpoint.genres.url,
                method: .get([
                    URLQueryItem(name: "language", value: lang)
                ]),
                modelType: Genres.self
            )
            
            let response = try await httpClient.load(resource)
            self.movieGenres = response.genres
        } catch {
            setError(error)
        }
    }
    private func getSerieGenres() async {
        do {
            let resource = Resource(
                url: SerieEndpoint.genres.url,
                method: .get([
                    URLQueryItem(name: "language", value: lang)
                ]),
                modelType: Genres.self
            )
            
            let response = try await httpClient.load(resource)
            self.serieGenres = response.genres
        } catch {
            setError(error)
        }
    }
    
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
}
