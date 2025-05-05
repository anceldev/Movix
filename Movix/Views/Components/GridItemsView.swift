//
//  GridItemsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct GridItemsView<T: MediaTMDBProtocol>: View {
    let mediaItems: [T]
    var mediaType: MediaType
    let columns: [GridItem]
//    let columns: ViewOption
    @Environment(NavigationManager.self) var navigationManager
    
    init(mediaItems: [T], mediaType: MediaType, viewOption: ViewOption) {
        self.mediaItems = mediaItems
        self.mediaType = mediaType
        self.columns = Array<GridItem>(repeating: .init(.flexible()), count: viewOption == .gridx3 ? 3 : 2)
    }
    
    var body: some View {
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
    }
}

struct GridItemsView3<T:UserItemCollectionMediaProtocol>: View {
    let mediaItems: [T]
    var mediaType: MediaType
    let columns: [GridItem]
    @Environment(NavigationManager.self) var navigationManager
    
    init(mediaItems: [T], mediaType: MediaType, columns: Int) {
        self.mediaItems = mediaItems
        self.mediaType = mediaType
        self.columns = Array<GridItem>(repeating: .init(.flexible()), count: columns)
        print(mediaItems)
    }

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 8) {
                     var seenMediaIds = Set<Int>()
                    ForEach(mediaItems.filter({ seenMediaIds.insert($0.id!).inserted })) { ratedItem in
                         Button {
                             navigationManager.navigate(
                                to: mediaType == .movie
                                ? .movieDetails(id: ratedItem.media.id)
                                : .serieDetails(id: ratedItem.media.id)
                             )
                         } label: {
                             MediaGridItem(posterPath: ratedItem.media.posterPath , userRating: ratedItem.rating)
                         }
                     }
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    GridItemsView(mediaItems: [PreviewData.movie], mediaType: .movie, viewOption: .gridx2)
        .environment(MoviesViewModel())
        .environment(NavigationManager())
}

