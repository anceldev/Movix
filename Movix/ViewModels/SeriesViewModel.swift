//
//  TvViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 27/2/25.
//

import Foundation
import Observation

@Observable
final class SeriesViewModel {
    var trendingSeries = [TvSerie]()
    var searchedSeries = [TvSerie]()
    
    var errorMessage: String?
    private var trendingSeriesPage: Int = 0
    
    private var httpClient = HTTPClient()
    private var lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
    
    init() {
        Task {
            await getTrendingSeries()
        }
    }
    
    func getTrendingSeries() async {
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
        } catch  {
            setError(error)
        }
    }
    func getSearchedSeries(searchTerm: String) async {
        
    }
    
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
}
