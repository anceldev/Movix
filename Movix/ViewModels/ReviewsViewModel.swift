//
//  ReviewsViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 14/3/25.
//

import Foundation
import Observation

@Observable
final class ReviewsViewModel {
    var reviews: [Review] = []
    var errorMessage: String?
    
    private var httpClient = HTTPClient()
    private var lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
    
    func getReviews(id: Int, mediaType: MediaType) async {
        do {
            let resource = Resource(
                url: mediaType == .movie ? MovieEndpoint.reviews(id).url : SerieEndpoint.reviews(id).url,
                method: .get([
                    URLQueryItem(name: "language", value: lang),
                    URLQueryItem(name: "page", value: "1")
                ]),
                modelType: PageCollection<Review>.self
            )
            let response = try await httpClient.load(resource)
            self.reviews = response.results
            
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
}
