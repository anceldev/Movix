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
    var errorMessage: String?
    private var favoritesPage = 1
    
    private var httpClient = HTTPClient()
    
    init(user: User) {
        self.user = user
        Task {
            await getFavoriteMovies()
        }
    }
    
//    func getFavoriteMovies() {
//        do {
//            
//        } catch <#pattern#> {
//            <#statements#>
//        }
//    }
    
//    func addFavoriteMovie(movie: Movie) async {
//        do {
//            
//        } catch {
//            print(error)
//            print(error.localizedDescription)
//            self.errorMessage = error.localizedDescription
//        }
//    }
    func addFavoriteMovie(movie: Movie) async {
        do {
            let sessionId = UserDefaults.standard.string(forKey: "session_id") ?? ""
            let parameters = [
                "media_type": "movie",
                "media_id": movie.id,
                "favorite": true
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
            user.favorites.append(movie)
            
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    func getFavoriteMovies() async {
        do {
            let resource = Resource(
                url: Endpoints.favorites(user.id).url,
                method: .get([
                    URLQueryItem(name: "language", value: user.lang),
                    URLQueryItem(name: "page", value: "\(favoritesPage)"),
                    URLQueryItem(name: "sort_by", value: "created_at.asc")
                ]),
                modelType: PageCollection<Movie>.self
            )
            let favoriteMovies = try await httpClient.load(resource)
            print(favoriteMovies.results)
            self.user.favorites = favoriteMovies.results
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
}
