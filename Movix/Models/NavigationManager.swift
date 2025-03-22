//
//  SeriesRouter.swift
//  Movix
//
//  Created by Ancel Dev account on 22/3/25.
//

import Foundation
import SwiftUI
import Observation



enum RouterDestination: Hashable {
    case serieDetails(id: Int)
    case movieDetails(id: Int)
    case providers(id: Int, mediaType: MediaType)
    case season(number: Int, path: String?, episodes: Int, airDate: Date?, serieId: Int)
    case languages
    case countries
    case people(id: Int)
}


@MainActor
@Observable
final class NavigationManager: Observable {
    var path: [RouterDestination] = []
    var activeTab: MainTabOption = .movies
    
    func navigate(to destination: RouterDestination) {
        path.append(destination)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    func navigateToRoot() {
        path = []
    }
    func switchTab(to tab: MainTabOption) {
        path = []
        activeTab = tab
    }
}

 @MainActor
 extension View {
     func withAppRouter() -> some View {
         navigationDestination(for: RouterDestination.self) { router in
             switch router {
             case .serieDetails(let id):
                 SerieScreen(serieId: id)
                     .navigationBarBackButtonHidden()
             case .movieDetails(let id):
                 MovieScreen(movieId: id)
                     .navigationBarBackButtonHidden()
             case .providers(let id, let mediaType):
                 ProvidersScreen(mediaId: id, mediaType: mediaType)
                     .navigationBarBackButtonHidden()
             case .season(let number, let path, let episodes, let airDate, let serieId):
                 SeasonScreen(seasonNumber: number, posterPath: path, episodes: episodes, releaseDate: airDate, serieId: serieId)
                     .navigationBarBackButtonHidden()
             case .languages:
                 LanguageScreen()
                     .navigationBarBackButtonHidden()
             case .countries:
                 CountryScreen()
                     .navigationBarBackButtonHidden()
             case .people(let actorId):
                 ActorScreen(id: actorId)
                     .navigationBarBackButtonHidden()
             }
         }
     }
 }
