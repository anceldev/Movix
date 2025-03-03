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
    
    init(_ seasons: [TvSeason]){
        self.seasons = seasons
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Seasons")
                .font(.system(size: 22, weight: .medium))
                VStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(seasons) { season in
                                NavigationLink {
//                                    Text("\(season.seasonNumer)")
                                    SeasonScreen(season: season, serieId: serieVM.serie?.id ?? 0)
                                        .navigationBarBackButtonHidden()
                                        .environment(serieVM)
                                } label: {
                                    SeasonLabel(season: season)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)
        }
    }
}



#Preview {
    SeasonsView(
        [
            TvSerie.that70show.seasons![0],
            TvSerie.that70show.seasons![1],
            TvSerie.that70show.seasons![2],
            TvSerie.that70show.seasons![3],
        ]
    )
}
