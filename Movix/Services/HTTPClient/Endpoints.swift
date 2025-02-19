//
//  Endpoints.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation

enum MediaType: String {
    case movie
    case tv
}
enum TimeWindow: String {
    case day
    case week
}

enum Endpoints {
    case movie(String) //
    case trending(MediaType, TimeWindow, Int) //
    case search(String, MediaType)
    case person(String)
    case genre(MediaType)
    case cast(String, MediaType)
    case languages
    case review(MediaType, String)
    case movieProviders(Int)
    
    case favorites(Int)
    case addFavorite(Int)
    
    case getAccount(String)
    case deleteSession
    case requestToken
    case validateTokenWithLogin
    case createSession
    
    private static let apiKey = Bundle.main.infoDictionary?["MovixAPIKey"] as! String
    private static let baseUrlPath = "https://api.themoviedb.org/3/"
    
    var endpoint: String {
        switch self {
        case .movie: return "movie"
        case .trending: return "trending/"
            
        case .favorites(let accountId): return ""
        case .addFavorite: return ""
            
        case .search: return "search/"
        case .person: return "person/"
        case .genre: return "genre/"
        case .cast: return "credits"
        case .languages: return "languages"
        case .review: return "reviews"
        case .movieProviders: return "providers"
        case .getAccount: return "account"
        case .deleteSession: return "/authentication/session"
        case .requestToken: return "/authentication/token/"
        case .validateTokenWithLogin: return "/authentication/token/validate_with_login"
        case .createSession: return "/authentication/session/"
        }
    }
    
    var url: URL {
        switch self {
        case .movie(let movieId):
            return URL(string: Self.baseUrlPath + self.endpoint + "/\(movieId)?api_key=\(Self.apiKey)")!
        case .trending(let media, let timeWindow, let page):
            //            return URL(string: Self.baseUrlPath + self.endpoint + "\(media.rawValue)/\(timeWindow.rawValue)?api_key=\(Self.apiKey)&page=\(page)")!
            return URL(string: Self.baseUrlPath + self.endpoint + "\(media.rawValue)/\(timeWindow.rawValue)?api_key=\(Self.apiKey)")!
            
        case .favorites(let accountId):
            //https://api.themoviedb.org/3/account/{account_id}/favorite/movies
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
            
        case .getAccount(let sessionId):
            return URL(string: Self.baseUrlPath + self.endpoint + "?api_key=\(Self.apiKey)")!
        case .deleteSession:
            return URL(string: Self.baseUrlPath + self.endpoint + "?api_key=\(Self.apiKey)")!
        case .requestToken:
            return URL(string: Self.baseUrlPath + self.endpoint + "new?api_key=\(Self.apiKey)")!
        case .validateTokenWithLogin:
            return URL(string: Self.baseUrlPath + self.endpoint + "?api_key=\(Self.apiKey)")!
        case .createSession:
            return URL(string: Self.baseUrlPath + self.endpoint + "new?api_key=\(Self.apiKey)")!
        }
    }
}
