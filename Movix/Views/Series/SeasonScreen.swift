//
//  SeasonScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct SeasonScreen: View {
    let seasonNumber: Int
    let posterPath: String?
    let episodes: Int
    let releaseDate: Date?
    let serieId: Int
    
    @State private var image: Image?
    @State private var seasonVM = SeasonViewModel()
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                PosterMediaView(
                    posterPath: posterPath,
                    duration: "\(episodes) Ep.",
                    releaseDate: seasonVM.season?.airDate?.releaseDate()
                )
                VStack {
                    if let seasonOverview = seasonVM.season?.overview, !seasonOverview.isEmpty {
                        OverviewView(title: seasonVM.season?.name, overview: seasonVM.season?.overview)
                    }
                    if let episodes = seasonVM.season?.episodes {
                        LazyVStack(spacing: 32) {
                            ForEach(episodes) { episode in
                                EpisodeView(name: episode.name, overview: episode.overview, stillPath: episode.stillPath)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .background(.bw10)
        .ignoresSafeArea(.container, edges: .top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .swipeToDismiss()
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    navigationManager.navigateBack()
                } label: {
                    BackButton(label: "Serie")
                }
            }
        }
        .task {
            await seasonVM.getSeasonDetails(
                seasonId: serieId,
                seasonNumber: seasonNumber
            )
        }
    }
}
