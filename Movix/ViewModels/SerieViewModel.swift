//
//  SerieViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 28/2/25.
//

import Foundation
import Observation
import SwiftUI

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
    func getSerieCredits(id: Int) async {
        do {
            let resource = Resource(
                url: SerieEndpoint.agregateCredits(id).url,
                modelType: Credit.self
            )
            let response = try await httpClient.load(resource)
            self.cast = response.cast
        } catch {
            setError(error)
        }
    }
    
    func getRecommendedSeries(serieId: Int) async -> [TvSerie] {
        do {
            let resource = Resource(
                url: SerieEndpoint.recommended(serieId).url,
                method: .get([
                    URLQueryItem(name: "language", value: lang),
                    URLQueryItem(name: "page", value: "1")
                ]),
                modelType: PageCollection<TvSerie>.self
            )
            let response = try await httpClient.load(resource)
            return response.results
        } catch {
            setError(error)
            return []
        }
    }
    
    func loadPosterImage(imagePath: String?) async -> Image? {
        do {
            guard let imagePath else { return nil }
            if let uiImage = try await ImageCacheManager.shared.getImage(forKey: imagePath) {
                return Image(uiImage: uiImage)
            }
            if let posteUiImage = await HTTPClient.getPosterUIImage(posterPath: imagePath) {
                try await ImageCacheManager.shared.saveImage(posteUiImage, forKey: imagePath)
                return Image(uiImage: posteUiImage)
            }
            return nil
        } catch {
            setError(error)
            return nil
        }
    }
    
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
}
