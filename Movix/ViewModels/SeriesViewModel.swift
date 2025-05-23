//
//  TvViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 27/2/25.
//

import Foundation
import Observation
import Combine

enum LoadFlow {
    case loading
    case loaded
    case error
}

@Observable
final class SeriesViewModel {
    var trendingSeries = [TvSerie]()
    var searchedSeries = [TvSerie]()
    var series = [TvSerie]()
    
    var errorMessage: String?
    var loadFlow: LoadFlow = .loaded
    var isLoading = false
    
    private var trendingSeriesPage: Int = 0
    private var searchPage: Int = 0
    
    private var httpClient = HTTPClient()
    private var lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
    
    private var currentQuery = ""
    
    
    init() {
        Task {
            await loadTrending()
        }
    }
    
    func clearSearchQuery() {
        series = []
        isLoading = false
    }
        
    func loadTrending() async {
        isLoading = true
        defer { isLoading = false }
        
        self.loadFlow = .loading
        self.trendingSeriesPage += 1
        do {
            let resource = Resource(
                url: SerieEndpoint.trending(.week).url,
                method: .get([
                    URLQueryItem(name: "page", value: "\(self.trendingSeriesPage)"),
                    URLQueryItem(name: "language", value: lang)
                ]),
                modelType: PageCollection<TvSerie>.self
            )
            let response = try await httpClient.load(resource)
            self.trendingSeries += response.results
            self.loadFlow = .loaded
        } catch  {
            setError(error)
            self.loadFlow = .error
        }
    }
    func searchSeries(searchTerm: String) async {
        isLoading = true
        defer { isLoading = false }
        if currentQuery == searchTerm {
            searchPage += 1
        } else {
            currentQuery = searchTerm
            searchPage = 1
            self.series = []
        }
        do {
            let resource = Resource(
                url: SerieEndpoint.search.url,
                method: .get([
                    URLQueryItem(name: "query", value: searchTerm),
                    URLQueryItem(name: "language", value: lang),
                    URLQueryItem(name: "page", value: "\(self.searchPage)")
                ]),
                modelType: PageCollection<TvSerie>.self
            )
            let response = try await httpClient.load(resource)
            self.series += response.results

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
