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

    @Environment(NavigationManager.self) var navigationManager
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                var seenMediaIDS = Set<Int>()
                ForEach(mediaItems.filter { seenMediaIDS.insert($0.id).inserted }) { media in
                    Button {
                        navigationManager.navigate(to: mediaType == .movie ? .movieDetails(id: media.id) : .serieDetails(id: media.id))
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
        }
        .scrollIndicators(.hidden)
    }
}

// #Preview {
//     MediaRowLayout<Movie>(mediaItems: [Movie.preview], mediaType: .movie)
// }
