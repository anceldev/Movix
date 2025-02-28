//
//  SearchedTvShows.swift
//  Movix
//
//  Created by Ancel Dev account on 27/2/25.
//

import SwiftUI

struct SearchedTvShows: View {
    @State private var tvVM = TvViewModel()
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ListItemsView(movies: tvVM.trendingTvShows, searchTerm: .constant(""))
            }
            .scrollIndicators(.hidden)
        }
//        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
