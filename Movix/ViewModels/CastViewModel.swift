//
//  CastViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation

@Observable
final class CastViewModel {
    var cast = [Cast]()
    var errorMessage: String?
    
    init(id: Int) {
        Task {
            await getCast(movieId: id)
        }
    }
    
    func getCast(movieId: Int) async {
        do {
            let resource = Resource(
                url: Endpoints.cast("\(movieId)", .movie).url,
                modelType: Credit.self
            )
            let cast = try await HTTPClient.shared.load(resource)
            self.cast = cast.cast
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
}
