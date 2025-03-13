//
//  MediaRowLayout.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct MediaRowLayout<T: MediaItemProtocol>: View {
    let mediaItems: [T]
    let mediaType: MediaType
    var body: some View {
        ScrollView(.vertical) {
//            LazyVStack(alignment: .leading) {
            VStack(alignment: .leading) {
                var seenMediaIDS = Set<Int>()
                ForEach(mediaItems.filter { seenMediaIDS.insert($0.id).inserted }) { media in
                    NavigationLink {
                        Group {
                            switch mediaType {
                            case .movie:
                                MovieScreen(movieId: media.id)
                                    .navigationBarBackButtonHidden()
                            case .tv:
                                SerieScreen(serieId: media.id)
                                    .navigationBarBackButtonHidden()
                            }
                        }
                    } label: {
                        MediaRow(
                            title: media.title,
                            backdropPath: media.backdropPath,
                            releaseDate: media.releaseDate,
                            voteAverage: media.voteAverage) {
                                EmptyView()
                            }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    MediaRowLayout<Movie>(mediaItems: [Movie.preview], mediaType: .movie)
}
