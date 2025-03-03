//
//  GridItemsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct GridItemsView<T: MediaItemProtocol>: View {
    let mediaItems: [T]
    @Binding var searchTerm: String
    var mediaType: MediaType
    let columns: [GridItem]
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 8) {
                    var seenMovieIDs = Set<Int>()
                    ForEach(mediaItems.filter { seenMovieIDs.insert($0.id).inserted }) { media in
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
                            MediaGridItem(posterPath: media.posterPath, voteAverage: media.voteAverage)
                        }
                    }
                    
                }
                .scrollIndicators(.hidden)
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    GridItemsView(mediaItems: [Movie.preview], searchTerm: .constant(""), mediaType: .movie, columns: [GridItem(.flexible()), GridItem(.flexible())])
        .environment(MoviesViewModel())
}

