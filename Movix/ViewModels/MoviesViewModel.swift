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
    var trendingMovies = [ShortMovie]()
    var searchedMovies = [ShortMovie]()
    var movieGenres = [Genre]()
    var tvGenre = [Genre]()
    var errorMessage: String?
    
    private var trendingMoviesPage: Int = 0
    private var searchedMoviesPage: Int = 0
    private var favoriteMoviesPage: Int = 0
    
//    private let httpClient = HTTPClient()
    private let httpClient = HTTPClient.shared
    
    init() {
        Task {
            self.movieGenres = await getGenres(lang: "en", mediaType: .movie)
            self.tvGenre = await getGenres(lang: "en", mediaType: .tv)
            await getTrendingMovies(lang: "en")
        }
    }
    
    private func getGenres(lang: String = "en", mediaType: MediaType) async -> [Genre]{
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
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return []
        }
    }
    
    func getTrendingMovies(lang: String = "en") async {
        self.trendingMoviesPage += 1
        do {
            let resource = Resource(
                url: Endpoints.trending(.movie, .week, self.trendingMoviesPage).url,
                method: .get([
                    URLQueryItem(name: "language", value: lang),
                    URLQueryItem(name: "page", value: "\(self.trendingMoviesPage)")
                ]),
                modelType: PageCollection<ShortMovie>.self
            )
            let trendingMovies = try await httpClient.load(resource)
            self.trendingMovies += trendingMovies.results
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = errorMessage
        }
    }
    func searchMovies(searchTerm: String, lang: String = "en") async {
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
                modelType: PageCollection<ShortMovie>.self
            )
            print("Searching on page: \(self.searchedMoviesPage)")
            let searchedMovies = try await httpClient.load(resource)
            self.searchedMovies += searchedMovies.results
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = errorMessage
        }
    }
    
    func getBackdropImage(backdropPath: String?) async -> Image? {
        guard let posterPath = backdropPath else {
            return nil
        }
        do {
//            if let cachedImage = try await ImageCacheManager.shared.getImage(forKey: posterPath) {
//                return Image(uiImage: cachedImage)
//            }
            
            var url = URL(string: "https://image.tmdb.org/t/p/w780\(posterPath)")!
            let (dataW780, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataW780) {
//                try await ImageCacheManager.shared.saveImage(uiImage, forKey: posterPath)
                return Image(uiImage: uiImage)
            }
            url = URL(string: "https://image.tmdb.org/t/p/w1280\(posterPath)")!
            let (dataW1280, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataW1280) {
//                try await ImageCacheManager.shared.saveImage(uiImage, forKey: posterPath)
                return Image(uiImage: uiImage)
            }
            url = URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")!
            let (dataOriginal, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataOriginal) {
//                try await ImageCacheManager.shared.saveImage(uiImage, forKey: posterPath)
                return Image(uiImage: uiImage)
            }
            return nil
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return nil
        }
    }
    func getPosterImage(posterPath: String?) async -> Image? {
        guard let posterPath = posterPath else {
            return nil
        }
        do {
//            if let cachedImage = try await ImageCacheManager.shared.getImage(forKey: posterPath) {
//                return Image(uiImage: cachedImage)
//            }
            
            var url = URL(string: "https://image.tmdb.org/t/p/w780\(posterPath)")!
            let (dataW780, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataW780) {
//                try await ImageCacheManager.shared.saveImage(uiImage, forKey: posterPath)
                return Image(uiImage: uiImage)
            }
            url = URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")!
            let (dataOriginal, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataOriginal) {
//                try await ImageCacheManager.shared.saveImage(uiImage, forKey: posterPath)
                return Image(uiImage: uiImage)
            }
            return nil
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return nil
        }
    }
}
