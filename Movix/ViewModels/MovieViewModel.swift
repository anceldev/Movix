////
////  MovieViewModel.swift
////  Movix
////
////  Created by Ancel Dev account on 4/11/23.
////
//
//import Foundation
//
//@MainActor
//class MovieViewModel: ObservableObject {
//    private let service = SearchService()
//    private let movieService = MovieService()
//    
//    @Published var movies = [Movie]()
//    @Published var movie: Movie
//    
//    init(){
//        self.movie = Movie(adult: nil, title: nil, backdropPath: nil, posterPath: nil, id: 0, genres: nil, releaseDate: nil, runtime: nil, overview: nil, budget: nil, productionCountries: nil, spokenLanguages: nil, voteAverage: nil, voteCount: nil)
//    }
//    
//    func getMovies(withQuery query: String){
//        Task {
//            do {
//                self.movies = try await service.searchMovies(query: query)
//            }
//            catch {
//                fatalError("SearchService error searching Movies")
//            }
//        }
//    }
//    func getTrending() {
//        Task {
//            do {
//                self.movies = try await service.searchTrending()
//            }
//            catch {
//                fatalError("SearchService error searching Trending Movies")
//            }
//        }
//    }
//    
//    // Build de url of the image looking at ConfigurationDetails model. !! Incomplete
//    func urlImageMovie(urlBackdrop image: String) -> URL {
//        let urlString = "https://image.tmdb.org/t/p/" + "w300" + image
//        Task {
//            do {
//                let (_, response) = try await URLSession.shared.data(from: URL(string: urlString)!)
//                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                    throw UFDError.reponseFailed
//                }
//            }
//            catch {
//                print("Error getting image")
//            }
//        }
//        return URL(string: urlString)!
//    }
//    
//    func getPosterUrl(urlPoster image: String) -> URL {
//        
//        let urlString = "https://image.tmdb.org/t/p/" + "w300" + image
//        
//        Task {
//            do {
//                let (_, response) = try await URLSession.shared.data(from: URL(string: urlString)!)
//                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                    throw UFDError.reponseFailed
//                }
//            }
//            catch {
//                print("Error getting image")
//            }
//        }
//        return URL(string: urlString)!
//    }
//    
//    func getDetails(forMovie id: Int){
//        Task {
//            do {
//                self.movie = try await movieService.details(forMovie: id)!
//                print("catched details for movie: " + self.movie.title!)
//            }
//            catch {
//                fatalError("MovieService error getting details for movie with id: \(id)")
//            }
//        }
//    }
//    func makeTags() -> String {
//        var tags = self.movie.productionCountries == nil ? "" : movie.productionCountries![0].name
//        //var tags = "" //self.movie.productionCountries == nil ? "" : movie.productionCountries![0].name
//        
//        //let country = isoCountry(country: self.movie.productionCountries![0].name)
//        
//        
//        if let genres = self.movie.genres {
//            var maxGenres = 2
//            tags += " |"
//            for genre in genres {
//                tags += " " + genre.name
//                maxGenres -= 1
//                if maxGenres == 0 {
//                    break
//                }
//            }
//        }
//        return tags
//    }
//    
//    /*func isoCountry(country: String) -> String {
//        
//    }*/
//}
