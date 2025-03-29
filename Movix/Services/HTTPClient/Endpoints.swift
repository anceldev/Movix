//
//  Endpoints.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation

fileprivate let apiKey = Bundle.main.infoDictionary?["MovixAPIKey"] as! String
fileprivate let baseUrlPath = "https://api.themoviedb.org/3/"

enum MediaType: String {
    case movie
    case tv
}
enum TimeWindow: String {
    case day
    case week
}

enum SerieEndpoint {
    case trending(TimeWindow)
    case serie(Int)
    case season(Int, Int)
    case episode(Int, Int, Int)
    case credits(Int)
    case agregateCredits(Int)
    case search
    case addRating(Int)
    case rated(Int)
    case details(Int, Int)
    case providers(Int)
    case favorites(Int)
    case reviews(Int)
    case recommended(Int)
    
    var url: URL {
        switch self {
        case .details(let serieId, let seasonNumber):
            return URL(string: baseUrlPath + "tv/\(serieId)/season/\(seasonNumber)")!
        case .addRating(let serieId):
            return URL(string: baseUrlPath + "tv/\(serieId)/rating")!
        case .rated(let accountId):
            return URL(string: baseUrlPath + "account/\(accountId)/rated/tv")!
        case .trending(let timeWindow):
            return URL(string: baseUrlPath + "trending/tv/\(timeWindow)")!
        case .serie(let serieId):
            return URL(string: baseUrlPath + "tv/\(serieId)")!
        case .season(let serieId, let season):
            return URL(string: baseUrlPath + "tv/\(serieId)/season/\(season)")!
        case .episode(let serieId, let season, let episode):
            return URL(string: baseUrlPath + "tv/\(serieId)/season/\(season)/episode/\(episode)")!
        case .credits(let serieId):
            return URL(string: baseUrlPath + "tv/\(serieId)/credits")!
        case .agregateCredits(let serieId):
            return URL(string: baseUrlPath + "tv/\(serieId)/aggregate_credits")!
        case .search:
            return URL(string: baseUrlPath + "search/tv")!
        case .providers(let serieId):
            return URL(string: baseUrlPath + "tv/\(serieId)/watch/providers")!
        case .favorites(let accountId):
            return URL(string: baseUrlPath + "account/\(accountId)/favorite/tv")!
        case .reviews(let serieId):
            return URL(string: baseUrlPath + "tv/\(serieId)/reviews")!
        case .recommended(let serieId):
            return URL(string: baseUrlPath + "tv/\(serieId)/recommendations")!
        }
    }
}

enum MovieEndpoint {
    case addRating(Int)
    case recommended(Int)
    case createList
    case credits(Int)
    case providers(Int)
    case reviews(Int)
    case popular
    
    var url: URL {
        switch self {
        case .addRating(let movieId):
            return URL(string: baseUrlPath + "movie/\(movieId)/rating")!
        case .recommended(let movieId):
            return URL(string: baseUrlPath + "movie/\(movieId)/recommendations")!
        case .createList:
            return URL(string: baseUrlPath + "list")!
        case .credits(let peopleId):
            return URL(string: baseUrlPath + "person/\(peopleId)/movie_credits")!
        case .providers(let movieId):
            return URL(string: baseUrlPath + "movie/\(movieId)/watch/providers")!
        case .reviews(let movieId):
            return URL(string: baseUrlPath + "movie/\(movieId)/reviews")!
        case .popular:
            return URL(string: baseUrlPath + "movie/popular")!
        }
    }
}


enum ConfigEndpoints {
    case languages
    case countries
    
    var url: URL {
        switch self {
        case .languages:
            return URL(string: baseUrlPath + "configuration/languages")!
        case .countries:
            return URL(string: baseUrlPath + "configuration/countries")!
        }
    }
}

enum Endpoints {
    case movie(String) //
    case trending(MediaType, TimeWindow) //
    case search(String, MediaType)
    case person(String)
    case genre(MediaType)
    case cast(String, MediaType)
    case languages
    case review(MediaType, String)
    case movieProviders(Int)
    
    case favorites(Int)
    case addFavorite(Int)
    
    case ratedMedia(Int, MediaType)
    
    case getAccount(String)
    case deleteSession
    case requestToken
    case validateTokenWithLogin
    case createSession
    
    case getProviders(MediaType)
    
    private static let apiKey = Bundle.main.infoDictionary?["MovixAPIKey"] as! String
    private static let baseUrlPath = "https://api.themoviedb.org/3/"
    
    var endpoint: String {
        switch self {
        case .movie: return "movie"
        case .trending: return "trending/"
            
        case .favorites: return ""
        case .addFavorite: return ""
            
        case .search: return "search/"
        case .person: return "person/"
        case .genre: return "genre/"
        case .cast: return "credits"
        case .languages: return "languages"
        case .review: return "reviews"
        case .movieProviders: return "providers"
        case .ratedMedia: return ""
        case .getAccount: return "account"
        case .deleteSession: return "authentication/session"
        case .requestToken: return "authentication/token/"
        case .validateTokenWithLogin: return "authentication/token/validate_with_login"
        case .createSession: return "authentication/session/"
        case .getProviders(.movie): return ""
        case .getProviders(.tv): return ""
        }
    }
    
    var url: URL {
        switch self {
        case .movie(let movieId):
            return URL(string: Self.baseUrlPath + self.endpoint + "/\(movieId)?api_key=\(Self.apiKey)")!
        case .trending(let media, let timeWindow):
            return URL(string: Self.baseUrlPath + self.endpoint + "\(media.rawValue)/\(timeWindow.rawValue)?api_key=\(Self.apiKey)")!
            
        case .favorites(let accountId):
            return URL(string: Self.baseUrlPath + "account/\(accountId)/favorite/movies")!
        case .addFavorite(let accountId):
            return URL(string: Self.baseUrlPath + "account/\(accountId)/favorite")!
        case .search(let query, let mediaType):
            return URL(string: Self.baseUrlPath + self.endpoint + "\(mediaType.rawValue)?api_key=\(Self.apiKey)&\(query)")!
        case .person(let personId):
            return URL(string: Self.baseUrlPath + self.endpoint + "\(personId)?api_key=\(Self.apiKey)")!
        case .genre(let mediaType):
            return URL(string: Self.baseUrlPath + self.endpoint + mediaType.rawValue + "/list?api_key=\(Self.apiKey)")!
        case .cast(let mediaId, let mediaType):
            return URL(string: Self.baseUrlPath + mediaType.rawValue + "/\(mediaId)/\(self.endpoint)?api_key=\(Self.apiKey)")!
        case .languages:
            return URL(string: Self.baseUrlPath + "configuration/languages")!
        case .review(let mediaType, let id):
            return URL(string: Self.baseUrlPath + mediaType.rawValue + "/\(id)/\(self.endpoint)")!
        case .movieProviders(let id):
            return URL(string: Self.baseUrlPath + "movie/\(id)/watch/providers?api_key=\(Self.apiKey)")!
            
        case .ratedMedia(let accountId, let mediaType):
            return URL(string: Self.baseUrlPath + "account/\(accountId)/rated/\(mediaType == .tv ? mediaType.rawValue : "\(mediaType)s")")!
            
        case .getAccount(let sessionId):
            return URL(string: Self.baseUrlPath + self.endpoint + "?api_key=\(Self.apiKey)&session_id=\(sessionId)")!
        case .deleteSession:
            return URL(string: Self.baseUrlPath + self.endpoint + "?api_key=\(Self.apiKey)")!
        case .requestToken:
            return URL(string: Self.baseUrlPath + self.endpoint + "new?api_key=\(Self.apiKey)")!
        case .validateTokenWithLogin:
            return URL(string: Self.baseUrlPath + self.endpoint + "?api_key=\(Self.apiKey)")!
        case .createSession:
            return URL(string: Self.baseUrlPath + self.endpoint + "new?api_key=\(Self.apiKey)")!
        case .getProviders(let mediaType):
            return URL(string: Self.baseUrlPath + "watch/profiders/\(mediaType.rawValue)")!
        }
    }
}
