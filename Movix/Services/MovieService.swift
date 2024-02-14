//
//  MovieService.swift
//  Movix
//
//  Created by Ancel Dev account on 24/10/23.
//

import Foundation

protocol MediaServiceProtocol {
//    func details(forMovie id: Movie.ID) async throws -> Movie?
}

final class MediaService: MediaServiceProtocol {
    
    typealias MovieListResult = MediaListResult<Movie>
    typealias TvSerieListResult = MediaListResult<TvSeries>
    
    var moviesList = MovieListResult()
    var tvSeriesList = TvSerieListResult()
    
    
    func searchMedia(query: String) async throws -> [any MediaProtocol] {
        let formattedQuery = query.replacingOccurrences(of: " ", with: "%20")
        let urlRequest = baseUrl + "search/movie" + "?" + api_key + "&query=" + formattedQuery + Lan.mainLan.query + "&include_adult=false&page=1"
        print(urlRequest)
        
        do {
            let moviesList = try await makeRequest(for: self.moviesList, url: urlRequest)
            self.moviesList = moviesList
            return moviesList.results
        }
        catch {
            throw ServiceErrors.mediaService
        }
    }
    
    func searchDetails(movie id: Int) async throws -> Movie {
        let urlRequest = baseUrl + "movie/" + "\(id)" + "?" + api_key + Lan.mainLan.query
        do {
            var requestMovie = Movie()
            requestMovie = try await makeRequest(for: requestMovie, url: urlRequest)
            return requestMovie
        }
        catch {
            throw ServiceErrors.movieNotFound
        }
    }
    private func makeRequest<T:Codable>(for item: T, url: String) async throws -> T {
        /// Generate request url
        guard let url = URL(string: url) else {
            throw ServiceErrors.wrongURL
        }
        /// Make request to API
        let(data, response) = try await URLSession.shared.data(from: url)
        /// Check API response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ServiceErrors.failedResponse
        }
        /// Decode response from API
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        }
        catch {
            throw ServiceErrors.noMatchModel
        }
    }
}

extension MediaService {
    static var service = MediaService()
}


//final class MovieService: MovieServiceProtocol{

//    func details(forMovie idMovie: Int) async throws -> Movie? {
//        let urlRequest = baseUrl + "\(idMovie)" + "?" + apiKey + trailingUrl
//        do {
//            let movie = try await UserFetchingData.fetchData(forItem: self.movie, withUrl: urlRequest)
//            self.movie = movie
//            return self.movie
//        }
//        catch {
//            print("[MovieViewModel] Error getting movie details")
//            throw error
//        }
//    }
    
//    func getcountries() async throws -> [Country] {
//        let urlRequest = "https://api.themoviedb.org/3/configuration/countries?api_key=4bd71d332c3d3c219fe01c8d465ba03a"
//        var countries = [Country]()
//        do {
//            let countriesList = try await UserFetchingData.fetchData(forItem: countries, withUrl: urlRequest)
//            countries = countriesList
//            return countries
//        }
//        catch {
//            fatalError("Movie Service can't get countries")
//        }
//    }
//}
