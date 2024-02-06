//
//  SearchService.swift
//  Movix
//
//  Created by Ancel Dev account on 1/11/23.
//

import Foundation

@MainActor
final class SearchService: ObservableObject{
//    typealias MoviePageableList = PageableList<Movie>
//    typealias TvSeriePageableList = PageableList<Serie>
//    typealias PeoplePageableList = PageableList<People>
    
//    private let leadingUrl = "https://api.themoviedb.org/3/search/movie"
//    private let trailingUrl = "&include_adult=false&language=en-US&page=1"
//    private let apiKey = "api_key=4bd71d332c3d3c219fe01c8d465ba03a"
    
//    var moviesList = MoviePageableList(page: nil, results: [], totalPager: nil, totalResults: nil)
    
//    func searchMovies(query: String) async throws -> [Movie]{
//        let formattedQuery = query.replacingOccurrences(of: " ", with: "%20")
//        let urlRequest = leadingUrl + "?" + apiKey + "&query=" + formattedQuery + trailingUrl
//        
//        do {
//            let movieList = try await UserFetchingData.fetchData(forItem: moviesList, withUrl: urlRequest)
//            self.moviesList = movieList
//            return movieList.results
//        }
//        catch {
//            print("[SearchService] Error searching movies.")
//            throw error
//        }
//    }
//    func searchTrending() async throws -> [Movie]{
//        let urlRequest = "https://api.themoviedb.org/3/trending/movie/day?" + apiKey + "&language=en-US"
//        do {
//            let movieList = try await UserFetchingData.fetchData(forItem: moviesList, withUrl: urlRequest)
//            self.moviesList = movieList
//            return movieList.results
//        }
//        catch {
//            print("[SearchService] Error searching trending movies")
//            throw error
//        }
//    }
}
