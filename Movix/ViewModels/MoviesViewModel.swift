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
    var trendingMovies = [Movie]()
    var searchedMovies = [Movie]()
    var similarMovies = [Movie]()
    var tvGenre = [Genre]()
    
    var movieCredits: MovieCredits?
    
    var errorMessage: String?
    
    private var trendingMoviesPage: Int = 0
    private var searchedMoviesPage: Int = 0
    private var favoriteMoviesPage: Int = 0
    
    private var lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
    
    private let httpClient = HTTPClient.shared
    
    init() {
        Task {
            self.tvGenre = await getGenres(lang: lang, mediaType: .tv)
            await getTrendingMovies()
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
    
    func getTrendingMovies() async {
        self.trendingMoviesPage += 1
        do {
            let resource = Resource(
//                url: Endpoints.trending(.movie, .week).url,
                url: MovieEndpoint.popular.url,
                method: .get([
                    URLQueryItem(name: "language", value: lang),
                    URLQueryItem(name: "page", value: "\(self.trendingMoviesPage)")
                ]),
//                modelType: PageCollection<ShortMovie>.self
                modelType: PageCollection<Movie>.self
            )
            let trendingMovies = try await httpClient.load(resource)
            self.trendingMovies += trendingMovies.results
        } catch {
            setError(error)
        }
    }
    func searchMovies(searchTerm: String) async {
        if self.searchedMovies.isEmpty {
            self.searchedMoviesPage = 1
        }
        else {
            self.searchedMoviesPage += 1
        }
        do {
            let resource = Resource(
                url: Endpoints.search(searchTerm, .movie).url,
                method: .get([
                    URLQueryItem(name: "query", value: searchTerm),
                    URLQueryItem(name: "language", value: lang),
                    URLQueryItem(name: "page", value: "\(self.searchedMoviesPage)")
                ]),
//                modelType: PageCollection<ShortMovie>.self
                modelType: PageCollection<Movie>.self
            )
            print("Searching on page: \(self.searchedMoviesPage)")
            let searchedMovies = try await httpClient.load(resource)
            self.searchedMovies += searchedMovies.results
        } catch {
            setError(error)
        }
    }
    
    func getBackdropImage(backdropPath: String?) async -> Image? {
        guard let posterPath = backdropPath else {
            return nil
        }
        do {
            var url = URL(string: "https://image.tmdb.org/t/p/w780\(posterPath)")!
            let (dataW780, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataW780) {
                return Image(uiImage: uiImage)
            }
            url = URL(string: "https://image.tmdb.org/t/p/w1280\(posterPath)")!
            let (dataW1280, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataW1280) {
                return Image(uiImage: uiImage)
            }
            url = URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")!
            let (dataOriginal, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataOriginal) {
                return Image(uiImage: uiImage)
            }
            return nil
        } catch {
            setError(error)
            return nil
        }
    }
    func getPosterImage(posterPath: String?) async -> Image? {
        guard let posterPath = posterPath else {
            return nil
        }
        do {
            var url = URL(string: "https://image.tmdb.org/t/p/w780\(posterPath)")!
            let (dataW780, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataW780) {
                return Image(uiImage: uiImage)
            }
            url = URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")!
            let (dataOriginal, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataOriginal) {
                return Image(uiImage: uiImage)
            }
            return nil
        } catch {
            setError(error)
            return nil
        }
    }
    
    func getSimilarMovies(movieId: Int) async -> [Movie] {
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
            self.similarMovies = similarMovies.results
            return self.similarMovies
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return []
        }
    }
    
    
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
}
