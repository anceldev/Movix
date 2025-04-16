//
//  CountriesViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 16/4/25.
//

import Foundation
import Observation

@Observable
final class CountriesViewModel {
    typealias Client = SupClient
    let supabase = Client.shared.supabase
    
    var countries = [Country]()
    var errorMessage: String?
    
    var country: String {
        didSet {
            UserDefaults.standard.set(country, forKey: "country")
        }
    }
    
    private var httpClient = HTTPClient()
    
    init(userCountry: String) {
        self.country = userCountry
    }
    
    func updateCountry(userId: UUID, newCountry: Country) async {
        do {
            self.country = newCountry.iso31661
            let response = try await supabase
                .from(SupabaseTables.users.rawValue)
                .update(["country": newCountry.iso31661])
                .execute()
            
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    
    private func getCountries() async {
        do {
            let resource = Resource(
                url: ConfigEndpoints.countries.url,
                method: .get([URLQueryItem(name: "language", value: "en")]),
                modelType: [Country].self
            )
            let response = try await httpClient.load(resource)
            self.countries = response
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    
}
