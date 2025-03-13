//
//  SeasonScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct SeasonScreen: View {
    @State private var image: Image?
    let season: TvSeason
    let serieId: Int
    @State private var seasonVM = SeasonViewModel()
    @Environment(SerieViewModel.self) var serieVM
    @Environment(\.dismiss) private var dismiss
    
    init(season: TvSeason, serieId: Int) {
        self.season = season
        self.serieId = serieId
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                PosterView(
                    posterPath: season.posterPath,
                    duration: "\(season.episodes?.count ?? 0) Ep.",
                    releaseDate: seasonVM.season?.airDate?.releaseDate()
//                    releaseDate: season.airDate?.releaseDate()
                )
                .environment(serieVM)
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
            .scrollIndicators(.hidden)
        }
        .background(.bw10)
        .ignoresSafeArea(.container, edges: .top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .swipeToDismiss()
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Serie")
                    }
                    .foregroundStyle(.blue1)
                }
            }
        }
        .task {
            await seasonVM.getSeasonDetails(
                seasonId: serieId,
                seasonNumber: season.seasonNumer
            )
        }
    }
}
