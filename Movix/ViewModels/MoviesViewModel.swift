//
//  MoviesViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation
import SwiftUI

@Observable
final class MoviesViewModel {
    var movies = [Movie]()
    var trending = [Movie]()
    var similar = [Movie]()
    
    var tvGenre = [Genre]()
    
    var movieCredits: MovieCredits?
    
    var errorMessage: String?
    var isLoading = false
    
    private var trendingPage: Int = 0
    private var searchPage: Int = 0
    private var currentQuery = ""
    
    private var lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
    
    private let httpClient = HTTPClient.shared
    
    init() {
        Task {
            self.tvGenre = await getGenres(lang: lang, mediaType: .serie)
            await loadTrending()
        }
    }
    
    private func getGenres(lang: String, mediaType: MediaType) async -> [Genre]{
        do {
            let resource = Resource(
                url: Endpoints.genre(mediaType).url,
                method: .get([
                    URLQueryItem(name: "language", value: lang)
                ]),
                modelType: Genres.self
            )
            let genres = try await httpClient.load(resource)
            return genres.genres
        } catch {
            setError(error)
            return []
        }
    }
    
    func loadTrending() async {
        isLoading = true
        defer { isLoading = false }
        
        self.trendingPage += 1
        do {
            let resource = Resource(
                url: MovieEndpoint.popular.url,
                method: .get([
                    URLQueryItem(name: "language", value: lang),
                    URLQueryItem(name: "page", value: "\(self.trendingPage)")
                ]),
                modelType: PageCollection<Movie>.self
            )
            let trendingMovies = try await httpClient.load(resource)
            self.trending += trendingMovies.results
        } catch {
            setError(error)
        }
    }
    func searchMovies(searchTerm: String) async {
        isLoading = true
        defer { isLoading = false }
        if currentQuery == searchTerm {
            searchPage += 1
        } else {
            currentQuery = searchTerm
            searchPage = 1
            self.movies = []
        }
        do {
            let resource = Resource(
                url: Endpoints.search(searchTerm, .movie).url,
                method: .get([
                    URLQueryItem(name: "query", value: searchTerm),
                    URLQueryItem(name: "language", value: lang),
                    URLQueryItem(name: "page", value: "\(self.searchPage)")
                ]),
                modelType: PageCollection<Movie>.self
            )
            let response = try await httpClient.load(resource)
            self.movies += response.results
        } catch {
            setError(error)
        }
    }
    
    func getRecommendedMovies(movieId: Int) async -> [Movie] {
        do {
            let resource = Resource(
                url: MovieEndpoint.recommended(movieId).url,
                method: .get([
                    URLQueryItem(name: "language", value: "en"),
                    URLQueryItem(name: "page", value: "1")
                ]),
                modelType: PageCollection<Movie>.self
            )
            let similarMovies = try await httpClient.load(resource)
            self.similar = similarMovies.results
            return self.similar
        } catch {
            setError(error)
            return []
        }
    }
    
    
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
}
