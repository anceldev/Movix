//
//  SeasonLabel.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct SeasonLabel: View {
    let season: TvSeason
    @State private var posterImage: Image?
    @Environment(SerieViewModel.self) var serieVM
    var body: some View {
        ZStack {
            VStack {
                if let posterImage {
                    posterImage
                        .resizable()
                }
                else {
                    TimeoutProgressView()
                }
            }
            .aspectRatio(2/3, contentMode: .fit)
            .frame(width: 120)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .task {
            if self.posterImage == nil {
//                self.posterImage = await serieVM.loadPosterImage(imagePath: season.posterPath)
                self.posterImage = await ImageLoader.shared.loadImage(for: season.posterPath, size: .poster)
            }
        }
    }
}
