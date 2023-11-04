//
//  MovieViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 4/11/23.
//

import Foundation

@MainActor

class MovieViewModel: ObservableObject {
    private let service = SearchService()
    private let movieService = MovieService()
    
    @Published var movies = [Movie]()
    
    init(){
        //self.movies = service.searchTrending()
    }
    
    func getMovies(withQuery query: String){
        Task {
            do {
                self.movies = try await service.searchMovies(query: query)
            }
            catch {
                fatalError("SearchService error searching Movies")
            }
        }
    }
    func getTrending() {
        Task {
            do {
                self.movies = try await service.searchTrending()
            }
            catch {
                fatalError("SearchService error searching Trending Movies")
            }
        }
    }
    
    // Build de url of the image looking at ConfigurationDetails model. !! Incomplete
    func urlImageMovie(urlBackdrop image: String) -> URL {
        let urlString = "https://image.tmdb.org/t/p/" + "w300" + image
        Task {
            do {
                let (_, response) = try await URLSession.shared.data(from: URL(string: urlString)!)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw UFDError.reponseFailed
                }
            }
            catch {
                print("Error getting image")
            }
        }
        return URL(string: urlString)!
    }
    
    func getPosterUrl(urlPoster image: String) -> URL {
        let urlString = "https://image.tmdb.org/t/p/" + "w300" + image
        Task {
            do {
                let (_, response) = try await URLSession.shared.data(from: URL(string: urlString)!)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw UFDError.reponseFailed
                }
            }
            catch {
                print("Error getting image")
            }
        }
        return URL(string: urlString)!
    }
    
    func getDetails(forMovie id: Int) -> Movie {
        return Movie.test
    }
}
