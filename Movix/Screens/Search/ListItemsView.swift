//
//  ListItemsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct ListItemsView<T: MediaItemProtocol>: View {
    
    let mediaItems: [T]
    @Binding var searchTerm: String
    @Environment(MoviesViewModel.self) var moviesVM
    @Environment(SeriesViewModel.self) var seriesVM
    @State private var showLoadButton = false
    let mediaType: MediaType

    var body: some View {
        @Bindable var viewModel = moviesVM
        LazyVStack(alignment: .leading) {
            var seenMediaIDs = Set<Int>()
            ForEach(mediaItems.filter { seenMediaIDs.insert($0.id).inserted }) { movie in
                NavigationLink {
                    MovieScreen(movieId: movie.id)
                        .navigationBarBackButtonHidden()
                        .toolbar(.hidden, for: .tabBar)
                } label: {
                    MediaRow(title: movie.title, backdropPath: movie.backdropPath, releaseDate: movie.releaseDate, voteAverage: movie.voteAverage) {
                        Image(.heartIcon)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ListItemsView(mediaItems: [ShortMovie.preview], searchTerm: .constant(""), mediaType: .movie)
            .environment(MoviesViewModel())
            .environment(SeriesViewModel())
    }
}
