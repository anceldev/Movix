//
//  File.swift
//  Movix
//
//  Created by Ancel Dev account on 1/3/25.
//

import Foundation
import Observation

@Observable
final class ProvidersViewModel {
    var providers: Providers = .init()
    
    private var lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
    private var httpClient = HTTPClient()
    
    init(mediaType: MediaType, mediaId: Int) {
        Task {
            await getProviders(mediaType: mediaType, id: mediaId)
        }
    }
    
    private func getProviders(mediaType: MediaType, id: Int) async {
        do {
            let endpoint = mediaType == .movie ? MovieEndpoint.providers(id).url : SerieEndpoint.providers(id).url
            let resource = Resource(
                url: endpoint,
                method: .get([
                    URLQueryItem(name: "language", value: lang)
                ]),
                modelType: Providers.self
            )
            let response = try await httpClient.load(resource)
            self.providers.buyProviders = response.buyProviders
            self.providers.rentProviders = response.rentProviders
            self.providers.streamProviders = response.streamProviders
        } catch {
            print(error)
            print(error.localizedDescription)
            
        }
    }
    deinit {
        print("Closing providers class...")
    }
}
