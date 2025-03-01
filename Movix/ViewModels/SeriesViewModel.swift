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
    
    var errorMessage: String?
    private var trendingMoviesPage: Int = 0
    
    private var httpClient = HTTPClient()
    private var lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
    
    init() {
        Task {
            await getTrendingSeries()
        }
    }
    
    func getTrendingSeries() async {
        do {
            let resource = Resource(
                url: SerieEndpoint.trending(.week).url,
                modelType: PageCollection<TvSerie>.self
            )
            let response = try await httpClient.load(resource)
            self.trendingSeries = response.results
        } catch  {
            setError(error)
        }
    }
    
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
}
