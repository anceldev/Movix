//
//  MovieViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation
import SwiftUI

@Observable
final class MovieViewModel {
    var movie: Movie?
    var cast = [Cast]()
    var reviews = [Review]()
    var providers: Providers = .init()
    
    private var lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
    
    var errorMessage: String?
        private let httpClient = HTTPClient.shared
    
    func getProviders(id: Int) async {
        do {
            let resource = Resource(
                url: Endpoints.movieProviders(id).url,
                modelType: Providers.self
            )
            let providers = try await httpClient.load(resource)
            self.providers = providers
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    func getMovieDetails(id: Int) async {
        do {
            let resource = Resource(
                url: Endpoints.movie("\(id)").url,
                method: .get([URLQueryItem(name: "language", value: lang)]),
                modelType: Movie.self
            )
            let movie = try await httpClient.load(resource)
            self.movie = movie
        } catch{
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    func getMovieCast(id: Int) async throws {
        do {
            let resource = Resource(
                url: Endpoints.cast("\(id)", .movie).url,
                method: .get([URLQueryItem(name: "language", value: lang)]),
                modelType: Credit.self
            )
            let movieCredits = try await httpClient.load(resource)
            self.cast = movieCredits.cast
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            throw error
        }
    }
    
    func getMovieReviews(id: Int) async {
        do {
            let resource = Resource(
                url: Endpoints.review(.movie, "\(id)").url,
                method: .get([
                    URLQueryItem(name: "language", value: lang),
                    URLQueryItem(name: "page", value: "1")
                ]),
                modelType: PageCollection<Review>.self
//                modelType: ReviewCollection.self
            )
            let reviews = try await httpClient.load(resource)
            self.reviews = reviews.results
            
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
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
