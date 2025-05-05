//
//  Provider.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation

struct Providers: Codable {
    var rentProviders: [Provider]
    var buyProviders: [Provider]
    var streamProviders: [Provider]
    enum CodingKeys: String, CodingKey {
        case results
    }
    enum CountryCodes: String, CodingKey {
        case AE, AR, AT, AU, BE, BG, BR, CA, CH, CL, CO, CZ, DE, DK, EC, EE, ES, FI, FR, GB
        case GR, HU, ID, IE, IN, IT, JP, KR, LT, LV, MX, MY, NL, NO, NZ, PE, PH, PL, PT, RO
        case RU, SE, SG, TH, TR, US, VE, ZA
    }
    enum ProviderTypes: String, CodingKey {
        case rent, buy, flatrate
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resultsContainer = try container.nestedContainer(keyedBy: CountryCodes.self, forKey: .results)
    
        let savedUserCountry = UserDefaults.standard.value(forKey: "country") as? String ?? "US"
        
        let userCountry = CountryCodes(rawValue: savedUserCountry) ?? .US
    
        let esContainer = try? resultsContainer.nestedContainer(keyedBy: ProviderTypes.self, forKey: userCountry)

        self.rentProviders = try esContainer?.decodeIfPresent([Provider].self, forKey: .rent) ?? []
        self.buyProviders = try esContainer?.decodeIfPresent([Provider].self, forKey: .buy) ?? []
        self.streamProviders = try esContainer?.decodeIfPresent([Provider].self, forKey: .flatrate) ?? []
    }
    init() {
        self.rentProviders = []
        self.buyProviders = []
        self.streamProviders = []
    }
    func encode(to encoder: any Encoder) throws { }
}
extension Providers {
    struct Provider: Identifiable, Decodable {
        let id: Int
        let providerName: String
        let providerPriority: Int
        let logoPath: URL?
        
        enum CodingKeys: String, CodingKey {
            case id = "provider_id"
            case providerName = "provider_name"
            case providerPriority = "display_priority"
            case logoPath = "logo_path"
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Providers.Provider.CodingKeys> = try decoder.container(keyedBy: Providers.Provider.CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: CodingKeys.id)
            self.providerName = try container.decode(String.self, forKey: CodingKeys.providerName)
            self.providerPriority = try container.decode(Int.self, forKey: CodingKeys.providerPriority)
            let logoUrl = try container.decodeIfPresent(String.self, forKey: CodingKeys.logoPath)
            self.logoPath = URL(string: "https://image.tmdb.org/t/p/w500" + (logoUrl ?? ""))
        }
    }
}
