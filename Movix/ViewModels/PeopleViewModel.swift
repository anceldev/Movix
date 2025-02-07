//
//  PeopleViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation
import Observation

@Observable
final class PeopleViewModel {
    var actor: People?
    var errorMessage: String?

    private let httpClient = HTTPClient.shared
    
    init() {
        self.actor = nil
        self.errorMessage = nil
    }
    
    func getActor(id: Int) async {
        do {
            let resource = Resource(
                url: Endpoints.person("\(id)").url,
                modelType: People.self
            )
            let actor = try await httpClient.load(resource)
            self.actor = actor
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = errorMessage
        }
    }
}
