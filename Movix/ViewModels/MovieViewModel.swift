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
            return similarMovies.results
            
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return []
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
            )
            let reviews = try await httpClient.load(resource)
            self.reviews = reviews.results
            
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
}
