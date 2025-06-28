//
//  FilterViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 15/5/25.
//

import Foundation
import Observation

/**
 queries:
 - include_adult
 - include_video_
 -language /////////
 -page ///////
 -primary_release_year
 -sort_by /////////
-vote_average.gte
 - with_genres
 */

enum FilterSortAttribute: String, Identifiable, CaseIterable {
    case firstAirDate = "first_air_date"
    case name
    case popularity
    case voteAverage = "vote_average"
    
    var id: String { return self.rawValue }
    var label: String {
        switch self {
        case .firstAirDate:
            NSLocalizedString("media-filter-sort-airdate", comment: "air date")
        case .name:
            NSLocalizedString("media-filter-sort-name", comment: "name")
        case .popularity:
            NSLocalizedString("media-filter-sort-popularity", comment: "popularity")
        case .voteAverage:
            NSLocalizedString("media-filter-sort-vote", comment: "vote average")
        }
    }
}
enum FilterSortOrder: String, Identifiable, CaseIterable {
    case asc
    case desc
    var id: String { return self.rawValue }
    var label: String {
        switch self {
        case .asc: "Asc"
        case .desc: "Desc"
        }
    }
}


@Observable
final class FilterViewModel {
    var genres = [Genre]()
    private var resultsPage = 1
    var selectedGenres = [Genre]()
    var selectedYear: Int?
    var selectedVote: Int?
    var selectedSortAttribute: FilterSortAttribute = .name
    var selectedSortOrder: FilterSortOrder = .asc
    
    var errorMessage: String?
    
    private let httpClient = HTTPClient.shared
    let lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
    
    func getGenres(for mediaType: MediaType) async {
        if mediaType == .movie {
            await getMovieGenres()
        } else {
            await getSerieGenres()
        }
    }
    
    func getResults<T:MediaTMDBProtocol>(mediaType: MediaType) -> [T] {
        do {
            
            return []
        } catch {
            setError(error)
        }
    }
    private func makeQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "language", value: lang)]
        queryItems.append(URLQueryItem(name: "page", value: "\(self.resultsPage)"))
        queryItems.append(URLQueryItem(name: "sort_by", value: "\(self.selectedSortAttribute.rawValue).\(self.selectedSortOrder.rawValue)"))

        if self.selectedYear != nil {
            queryItems.append(URLQueryItem(name: "primary_release_year", value: "\(self.selectedYear!)"))
        }
        if self.selectedVote != nil {
            queryItems.append(URLQueryItem(name: "vote_average.gte", value: "\(self.selectedVote!)"))
        }
        if self.selectedGenres.count > 0 {
//            for genre in selectedGenres {
            
        }
        
        
        return queryItems
    }
    
    func toggleSelectedGenre(_ genre: Genre) {
        guard let index = selectedGenres.firstIndex(of: genre) else {
            selectedGenres.append(genre)
            return
        }
        selectedGenres.remove(at: index)
    }
    
    private func getMovieGenres() async {
        do {
            let resource = Resource(
                url: MovieEndpoint.genres.url,
                method: .get([
                    URLQueryItem(name: "language", value: lang)
                ]),
                modelType: Genres.self
            )
            let response = try await httpClient.load(resource)
            self.genres = response.genres
            
        } catch {
            setError(error)
        }
    }
    private func getSerieGenres() async {
        do {
            let resource = Resource(
                url: SerieEndpoint.genres.url,
                method: .get([
                    URLQueryItem(name: "language", value: lang)
                ]),
                modelType: Genres.self
            )
            let response = try await httpClient.load(resource)
            self.genres = response.genres
            
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
