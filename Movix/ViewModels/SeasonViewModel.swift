//
//  SeasonViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import Foundation
import Observation

@Observable
final class SeasonViewModel {
    var season: TvSeason?
    
    var errorMessage: String?
    
    private var httpClient = HTTPClient()
    private var lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
    
    
    func getSeasonDetails(seasonId: Int, seasonNumber: Int) async {
        do {
            let resource = Resource(
                url: SerieEndpoint.seasonDetails(seasonId, seasonNumber).url,
                method: .get([
                    URLQueryItem(name: "language", value: lang)
                ]),
                modelType: TvSeason.self
            )
            let response = try await httpClient.load(resource)
            self.season = response
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
