//
//  SeasonsListView.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct SeasonsListView: View {
    let seasons: [TvSeason]
    let serieId: Int
    //    @Environment(SerieViewModel.self) var serieVM
    @State private var animatedIndices: Set<Int> = []
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Seasons")
                .font(.system(size: 22, weight: .medium))
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(Array(seasons.enumerated()), id:\.element.id) { index, season in
                            Button {
                                navigationManager.navigate(to: .season(number: season.seasonNumer, path: season.posterPath, episodes: season.episodes?.count ?? 0, airDate: season.airDate, serieId: serieId))
                            } label: {
                                SeasonLabel(season: seasons[index])
                                    .opacity(animatedIndices.contains(index) ? 1 : 0)
                                    .scaleEffect(animatedIndices.contains(index) ? 1 : 0.5)
                                    .animation(.easeInOut(duration: 0.7), value: animatedIndices.contains(index))
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)
        }
        .task {
            await animateSeasons()
        }
    }
    private func animateSeasons() async {
        for index in 0..<seasons.count {
            try? await Task.sleep(for: .milliseconds(200))
            let _ = withAnimation {
                animatedIndices.insert(index)
            }
        }
    }
}
