//
//  SeasonsView.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct SeasonsView: View {
    let seasons: [TvSeason]
    @Environment(SerieViewModel.self) var serieVM
    @State private var animatedIndices: Set<Int> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Seasons")
                .font(.system(size: 22, weight: .medium))
                VStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(Array(seasons.enumerated()), id:\.element.id) { index, season in
                                NavigationLink {
                                    SeasonScreen(season: season, serieId: serieVM.serie?.id ?? 0)
                                        .navigationBarBackButtonHidden()
                                        .environment(serieVM)
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



//#Preview {
//    SeasonsView(
//        [
//            TvSerie.that70show.seasons![0],
//            TvSerie.that70show.seasons![1],
//            TvSerie.that70show.seasons![2],
//            TvSerie.that70show.seasons![3],
//        ]
//    )
//}
