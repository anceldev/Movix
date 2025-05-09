//
//  GridItemsView2.swift
//  Movix
//
//  Created by Ancel Dev account on 6/5/25.
//

import SwiftUI

struct GridItemsView2: View {
    let mediaItems: [SupabaseMedia]
    var mediaType: MediaType
    let columns: [GridItem]
    
    @Environment(NavigationManager.self) var navigationManager
    
    init(mediaItems: [SupabaseMedia], mediaType: MediaType, columns: Int) {
        self.mediaItems = mediaItems
        self.mediaType = mediaType
        self.columns = Array<GridItem>(repeating: .init(.flexible()), count: columns)
    }

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 8) {
                     var seenMediaIds = Set<Int>()
                    ForEach(mediaItems.filter({ seenMediaIds.insert($0.id).inserted })) { item in
                         Button {
                             navigationManager.navigate(
                                to: mediaType == .movie
                                ? .movieDetails(id: item.id)
                                : .serieDetails(id: item.id)
                             )
                         } label: {
                             MediaGridItem(posterPath: item.posterPath)
                         }
                     }
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}
