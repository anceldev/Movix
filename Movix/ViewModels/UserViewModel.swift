//
//  UserViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import Foundation
import SwiftUI
@Observable
final class UserViewModel {
    var user: User
    var languages = [Language]()
    var countries = [Country]()
    var errorMessage: String?
    private var favoritesPage = 1
    private var ratedMoviesPage = 1
    private var favoriteSeriesPage = 1
    private var ratedSeriesPage = 1
    
    var lang: String {
        didSet {
            UserDefaults.standard.set(lang, forKey: "lang")
        }
    }
    var country: String {
        didSet {
            UserDefaults.standard.set(country, forKey: "country")
        }
    }
    
    private var httpClient = HTTPClient()
    private var sessionId = UserDefaults.standard.string(forKey: "session_id") ?? ""
    
    init(user: User) {
        self.user = user
        self.lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
        self.country = UserDefaults.standard.string(forKey: "country") ?? "US"
        Task {
            await getFavoriteMovies()
            await getRatedMovies()
            await getRatedSeries()
            await getFavoriteSeries()
        }
    }
    
    /// Add or removes a movie from favorites
    /// - Parameter movie: movie to add or delete.
    func toggleFavoriteMovie<T: MediaItemProtocol>(media: T, mediaType: MediaType) async {
        do {
            var isFavorite: Bool
            if mediaType == .movie {
                isFavorite = user.favoriteMovies.contains { $0.id == media.id }
            }
            else {
                isFavorite = user.favoriteSeries.contains(where: { $0.id == media.id })
            }
            
            let parameters = [
                "media_type": mediaType.rawValue,
                "media_id": media.id,
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
            if mediaType == .movie {
                if isFavorite {
                    user.favoriteMovies.removeAll { $0.id == media.id }
                }
                else {
                    user.favoriteMovies.append(media as! Movie)
                }
            }
            else {
                if isFavorite {
                    user.favoriteSeries.removeAll { $0.id == media.id }
                }
                else {
                    user.favoriteSeries.append(media as! TvSerie)
                }
            }
        } catch {
            setError(error)
        }
    }
    
    func isFavoriteMovie(id: Int) -> Bool {
        let favorite = user.favoriteMovies.first { $0.id == id }
        if favorite != nil {
            return true
        }
        return false
    }
    func isFavoriteSerie(id: Int) -> Bool {
        let favorite = user.favoriteSeries.first { $0.id == id }
        if favorite != nil {
            return true
        }
        return false
    }
    func isRatedMovie(id: Int) -> Bool {
        let rated = user.ratedMovies.first { $0.id == id }
        if rated != nil {
            return true
        }
        return false
    }
    func isRatedSerie(id: Int) -> Bool {
        let ratedSeries = user.ratedSeries.first { $0.id == id }
        if ratedSeries != nil {
            return true
        }
        return false
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
    func getFavoriteSeries() async {
        do {
            let resource = Resource(
                url: SerieEndpoint.favorites(user.id).url,
                method: .get([
                    URLQueryItem(name: "language", value: user.lang),
                    URLQueryItem(name: "page", value: "\(self.favoriteSeriesPage)"),
                    URLQueryItem(name: "session_id", value: sessionId),
                    URLQueryItem(name: "sort_by", value: "created_at.asc")
                ]),
                modelType: PageCollection<TvSerie>.self
            )
            let response = try await httpClient.load(resource)
            self.user.favoriteSeries = response.results
        } catch {
            setError(error)
        }
    }
    
    func getRatedSeries() async {
        do {
            let resource = Resource(
                url: SerieEndpoint.rated(user.id).url,
                method: .get([
                    URLQueryItem(name: "language", value: lang),
                    URLQueryItem(name: "page", value: "1"),
                    URLQueryItem(name: "session_id", value: sessionId),
                    URLQueryItem(name: "sort_by", value: "created_at.asc")
                ]),
                modelType: PageCollection<TvSerie>.self
            )
            let response = try await httpClient.load(resource)
            self.user.ratedSeries = response.results
        } catch {
            setError(error)
        }
    }
    func addMovieRating(movie: Movie, rating: Int) async {
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
    func addSerieRating(serie: TvSerie, rating: Int) async {
        do {
            let parameters = [
                "value": "\(rating)",
            ] as [String:Any?]
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let resource = Resource(
                url: SerieEndpoint.addRating(serie.id).url,
                method: .post(
                    postData,
                    [URLQueryItem(name: "session_id", value: sessionId)]
                ),
                modelType: Response.self
            )
            
            let rateResource = try await httpClient.load(resource)
            if let statusCode = rateResource.statusCode, statusCode == 1 {
                var ratedSerie = serie
                ratedSerie.rating = rating
                user.ratedSeries.append(ratedSerie)
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
    func getCurrentSerieRating(serieId: Int?) -> Int? {
        guard let serieId else { return nil }
        guard let serie = user.ratedSeries.first(where: { $0.id == serieId }),
              let ratingValue = serie.rating else { return nil }
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
                method: .get([
                    URLQueryItem(name: "language", value: user.lang),
                ]),
                modelType: [Language].self
            )
            let response = try await httpClient.load(resource)
            self.languages = response
        } catch {
            setError(error)
        }
    }
    func getCountries() async {
        do {
            let langCountries = "\(lang)-\(country)"
            let resource = Resource(
                url: ConfigEndpoints.countries.url,
                method: .get([
                    URLQueryItem(name: "language", value: langCountries)
                ]),
                modelType: [Country].self
            )
            let response = try await httpClient.load(resource)
            self.countries = response
        } catch {
            setError(error)
        }
    }

    func loadPosterImage(imagePath: String?) async -> Image? {
        do {
            guard let imagePath else { return nil }
            if let uiImage = try await ImageCacheManager.shared.getImage(forKey: imagePath) {
                return Image(uiImage: uiImage)
            }
            if let posteUiImage = await HTTPClient.getPosterUIImage(posterPath: imagePath) {
                try await ImageCacheManager.shared.saveImage(posteUiImage, forKey: imagePath)
                return Image(uiImage: posteUiImage)
            }
            return nil
        } catch {
            setError(error)
            return nil
        }
    }
    func getMediaCountries(_ codes: [String]) -> String {
        if self.countries.isEmpty { return "" }
        var foundedCountries: [Country] = []
        for code in codes {
            if let newCountry = self.countries.first(where: { $0.iso31661 == code }) {
                foundedCountries.append(newCountry)
            }
        }
        return foundedCountries.map { $0.nativeName }.joined(separator: ", ")
    }
    
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
}
