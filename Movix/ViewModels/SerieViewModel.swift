//
//  SerieViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 28/2/25.
//

import Foundation
import Observation

@Observable
final class SerieViewModel {
    var serie: TvSerie?
    var cast = [Cast]()
    var reviews = [Review]()
    var providers: Providers = .init()
    
    private var lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
    
    var errorMessage: String?
    private let httpClient = HTTPClient.shared
    
    
    func getSerieDetails(id: Int) async {
        do {
            let resource = Resource(
                url: SerieEndpoint.serie(id).url,
                method: .get([
                    URLQueryItem(name: "language", value: lang)
                ]),
                modelType: TvSerie.self
            )
            let response = try await httpClient.load(resource)
            self.serie = response
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
