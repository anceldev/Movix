//
//  MovieService.swift
//  Movix
//
//  Created by Ancel Dev account on 24/10/23.
//

import Foundation

protocol MovieServiceProtocol {
    func details(forMovie id: Movie.ID) async throws -> Movie?
}

final class MovieService: MovieServiceProtocol{
    var movie = Movie(adult: nil, title: nil, backdropPath: nil, posterPath: nil, id: 0, genres: nil, releaseDate: nil, runtime: nil, overview: nil, budget: nil, productionCountries: nil, spokenLanguages: nil, voteAverage: nil, voteCount: nil)
    
    private var apiKey = "api_key=4bd71d332c3d3c219fe01c8d465ba03a"
    private let baseUrl = "https://api.themoviedb.org/3/search/movie/"
    private let trailingUrl = "language=en-US"
    
    func details(forMovie idMovie: Int) async throws -> Movie? {
        let urlRequest = baseUrl + "\(idMovie)" + "?" + apiKey + trailingUrl
        do {
            let movie = try await UserFetchingData.fetchData(forItem: self.movie, withUrl: urlRequest)
            self.movie = movie
            return self.movie
        }
        catch {
            print("[MovieViewModel] Error getting movie details")
            throw error
        }
    }
}
