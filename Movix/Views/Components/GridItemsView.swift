//
//  GridItemsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

// struct GridItemsView<T: MediaItemProtocol>: View {
struct GridItemsView<T: MediaItemProtocol>: View {
    let mediaItems: [T]
    var mediaType: MediaType
    let columns: [GridItem]
    @Environment(NavigationManager.self) var navigationManager
    
    init(mediaItems: [T], mediaType: MediaType, columns: Int) {
        self.mediaItems = mediaItems
        self.mediaType = mediaType
//        self.columns = [GridItem(.flexible()) * columns]
        self.columns = Array<GridItem>(repeating: .init(.flexible()), count: columns)
    }

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 8) {
                     var seenMovieIDs = Set<Int>()
                     ForEach(mediaItems.filter { seenMovieIDs.insert($0.id).inserted }) { media in
                         Button {
                             navigationManager.navigate(to: mediaType == .movie ? .movieDetails(id: media.id) : .serieDetails(id: media.id))
                         } label: {
                             MediaGridItem(posterPath: media.posterPath, voteAverage: media.voteAverage)
                         }
                     }
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    GridItemsView(mediaItems: [Movie.preview], mediaType: .movie, columns: 2)
        .environment(MoviesViewModel())
        .environment(NavigationManager())
}

