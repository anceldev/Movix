//
//  UserViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import Foundation
import SwiftUI
import Supabase

@Observable
final class UserViewModel {
    
    typealias Client = SupClient
    let supabase = Client.shared.supabase
    
    var user: User
    var languages = [Language]()
    var countries = [Country]()
    var friends = [User]()
    
    var errorMessage: String?
    private var favoritesPage = 1
    private var ratedMoviesPage = 1
    private var favoriteSeriesPage = 1
    private var ratedSeriesPage = 1
    
    private var httpClient = HTTPClient()
    private var sessionId = UserDefaults.standard.string(forKey: "session_id") ?? ""
    
    init(user: User) {
        self.user = user
        Task {
            await getFavoriteMovies()
            await getRatedMovies()
            await getRatedSeries()
            await getFavoriteSeries()
        }
    }
    
    func getFriends() async {
        do {
            let response = try await supabase
                .from(SupabaseTables.friends.rawValue)
                .select("friend_id, status")
                .eq("user_id", value: user.id)
                .execute()
            
            let friendRequestDTO = try JSONDecoder().decode([FriendsRequestDTO].self, from: response.data)
        } catch {
            setError(error)
        }
    }
    
    
    func updateUserLanguage(lang: String?) async -> Void {
        guard let lang, lang != user.lang else { return }
        do {
            let response = try await supabase
                .from(SupabaseTables.users.rawValue)
                .update(["lang": lang])
                .eq("id", value: user.id)
                .execute()
            user.lang = lang
        } catch {
            setError(error)
        }
    }
    
    func updateUserCountry(country: String?) async -> Void {
        guard let country, country != user.country else { return }
        do {
            let response = try await supabase
                .from(SupabaseTables.users.rawValue)
                .update(["country": country])
                .eq("id", value: user.id)
                .execute()
            user.country = country
        } catch {
            setError(error)
        }
    }

    func toggleFavoriteMovie<T: MediaItemProtocol>(media: T, mediaType: MediaType) async {
        print("Toggle favorite")
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
        print("Getting favorite movies")
    }
    func getRatedMovies() async {
        print("Getting rated movies")
    }
    func getFavoriteSeries() async {
        print("Getting favorite series")
    }
    
    func getRatedSeries() async {
        print("Getting reated series")
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
    
//    func getLanguages() async {
//        do {
//            let resource = Resource(
//                url: ConfigEndpoints.languages.url,
//                method: .get([
//                    URLQueryItem(name: "language", value: user.lang),
//                ]),
//                modelType: [Language].self
//            )
//            let response = try await httpClient.load(resource)
//            self.languages = response
//        } catch {
//            setError(error)
//        }
//    }
    
    func getLanguages() async {
        do {
            languages = try await TMDBService.shared.getLanguages(lang: user.lang)
            languages.sort { $0.englishName < $1.englishName }
        } catch {
            setError(error)
        }
    }
    func getCountries() async {
        do {
            self.countries = try await TMDBService.shared.getCountries(lang: user.lang, country: user.country)
            countries.sort { $0.nativeName < $1.nativeName }
        } catch {
            setError(error)
        }
    }
    
//    func getCountries() async {
//        do {
//            let langCountries = "\(user.lang)-\(user.country)"
//            let resource = Resource(
//                url: ConfigEndpoints.countries.url,
//                method: .get([
//                    URLQueryItem(name: "language", value: langCountries)
//                ]),
//                modelType: [Country].self
//            )
//            let response = try await httpClient.load(resource)
//            self.countries = response
//        } catch {
//            setError(error)
//        }
//    }

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
