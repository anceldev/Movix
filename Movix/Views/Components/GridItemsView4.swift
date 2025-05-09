//
//  GridItemsView3.swift
//  Movix
//
//  Created by Ancel Dev account on 6/5/25.
//


import SwiftUI

struct GridItemsView4: View {
    let mediaItems: [TestUserMedia]
    var mediaType: MediaType
    let columns: [GridItem]
    
    @Environment(NavigationManager.self) var navigationManager
    
    init(mediaItems: [TestUserMedia], mediaType: MediaType, columns: Int) {
        self.mediaItems = mediaItems
        self.mediaType = mediaType
        self.columns = Array<GridItem>(repeating: .init(.flexible()), count: columns)
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


