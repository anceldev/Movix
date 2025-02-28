//
//  UserViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import Foundation

@Observable
final class UserViewModel {
    var user: User
    var languages = [Language]()
    var errorMessage: String?
    private var favoritesPage = 1
    private var ratedMoviesPage = 1
    
    var language: String {
        didSet {
            UserDefaults.standard.set(language, forKey: "lang")
        }
    }
    
    private var httpClient = HTTPClient()
    private var sessionId = UserDefaults.standard.string(forKey: "session_id") ?? ""
    
    init(user: User) {
        self.user = user
        self.language = UserDefaults.standard.string(forKey: "lang") ?? "en"
        Task {
            await getFavoriteMovies()
            await getRatedMovies()
        }
    }
    
    
    /// Add or removes a movie from favorites
    /// - Parameter movie: movie to add or delete.
    func toggleFavoriteMovie(movie: Movie) async {
        do {
            let isFavorite = user.favoriteMovies.contains { $0.id == movie.id }
            let parameters = [
                "media_type": "movie",
                "media_id": movie.id,
                "favorite": !isFavorite
            ] as [String:Any?]
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let resource = Resource(
                url: Endpoints.addFavorite(user.id).url,
                method: .post(postData, [
                    URLQueryItem(name: "session_id", value: sessionId)
                ]),
                modelType: Response.self
            )
            let response = try await httpClient.load(resource)
            guard let succes = response.success, succes == true else {
                throw RequestError.failedRequest
            }
            if isFavorite {
                user.favoriteMovies.removeAll { $0.id == movie.id }
            }
            else {
                user.favoriteMovies.append(movie)
            }
        } catch {
            setError(error)
        }
    }
    func getFavoriteMovies() async {
        do {
            let resource = Resource(
                url: Endpoints.favorites(user.id).url,
                method: .get([
                    URLQueryItem(name: "language", value: user.lang),
                    URLQueryItem(name: "page", value: "\(favoritesPage)"),
                    URLQueryItem(name: "sort_by", value: "created_at.asc"),
                    URLQueryItem(name: "session_id", value: sessionId),
                ]),
                modelType: PageCollection<Movie>.self
            )
            let favoriteMovies = try await httpClient.load(resource)
            self.user.favoriteMovies = favoriteMovies.results
        } catch {
            setError(error)
        }
    }
    func getRatedMovies() async {
        do {
            let resource = Resource(
                url: Endpoints.ratedMedia(user.id, .movie).url,
                method: .get([
                    URLQueryItem(name: "language", value: user.lang),
                    URLQueryItem(name: "page", value: "1"),
                    URLQueryItem(name: "session_id", value: sessionId),
                    URLQueryItem(name: "sort_by", value: "created_at.asc")
                ]),
                modelType: PageCollection<Movie>.self
            )
            let ratedCollection = try await httpClient.load(resource)
            self.user.ratedMovies = ratedCollection.results
        } catch {
            setError(error)
        }
    }
    func addRating(movie: Movie, rating: Int) async {
        do {
            let parameters = [
                "value": "\(rating)",
            ] as [String:Any?]
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let resource = Resource(
                url: MovieEndpoint.addRating(movie.id).url,
                method: .post(
                    postData,
                    [URLQueryItem(name: "session_id", value: sessionId)]
                ),
                modelType: Response.self
            )
            
            let rateResource = try await httpClient.load(resource)
            if let statusCode = rateResource.statusCode, statusCode == 1 {
                var ratedMovie = movie
                ratedMovie.rating = rating
                user.ratedMovies.append(ratedMovie)
            }
        } catch {
            setError(error)
        }
    }
    func getCurrentMovieRating(movieId: Int?) -> Int? {
        guard let movieId else { return nil }
        guard let movie = user.ratedMovies.first(where: { $0.id == movieId }),
              let ratingValue = movie.rating else { return nil }
        return ratingValue
    }
    
    func createList(name: String, description: String, language: String) async {
        do {
            let parameters = [
                "name": name,
                "description": description,
                "language": language
            ] as [String:Any?]
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let resource = Resource(
                url: MovieEndpoint.createList.url,
                method: .post(postData, []),
                modelType: Response.self
            )
            let response = try await httpClient.load(resource)
            guard let succes = response.success,
                  succes == true else {
                throw RequestError.listError
            }
            let listId = response.listId
            print(listId ?? 0)
            
        } catch {
            setError(error)
        }
    }
    
    func getLanguages() async {
        do {
            let resource = Resource(
                url: ConfigEndpoints.languages.url,
                modelType: [Language].self
            )
            let response = try await httpClient.load(resource)
            self.languages = response
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
