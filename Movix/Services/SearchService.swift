//
//  SearchService.swift
//  Movix
//
//  Created by Ancel Dev account on 1/11/23.
//

import Foundation

@MainActor
final class SearchService: ObservableObject{
    typealias MoviePageableList = PageableList<Movie>
    typealias TvSeriePageableList = PageableList<TvSerie>
    typealias PeoplePageableList = PageableList<People>
    
    private let leadingUrl = "https://api.themoviedb.org/3/search/movie"
    private let trailingUrl = "&include_adult=false&language=en-US&page=1"
    private let apiKey = "api_key=4bd71d332c3d3c219fe01c8d465ba03a"
    
    @Published var moviesList = MoviePageableList(page: nil, results: [], totalPager: nil, totalResults: nil)
    
    func searchMovies(query: String) async throws {
        let formattedQuery = query.replacingOccurrences(of: " ", with: "%20")
        let urlRequest = leadingUrl + "?" + apiKey + "&query=" + formattedQuery + trailingUrl
        
        do {
            print(urlRequest)
            let movieList = try await UserFetchingData.fetchData(forItem: moviesList, withUrl: urlRequest)
            self.moviesList = movieList
        }
        catch {
            print("[SearchService] Error searching movies.")
            throw error
        }
        print(self.moviesList.results.count)
    }
    func searchTrending() async throws {
        let urlRequest = "https://api.themoviedb.org/3/trending/movie/day?" + apiKey + "&language=en-US"
        do {
            print(urlRequest)
            let movieList = try await UserFetchingData.fetchData(forItem: moviesList, withUrl: urlRequest)
            self.moviesList = movieList
        }
        catch {
            print("[SearchService] Error searching trending movies")
            throw error
        }
    }
}
