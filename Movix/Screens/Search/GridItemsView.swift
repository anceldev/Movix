//
//  GridItemsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct GridItemsView: View {
    let movies: [ShortMovie]
    @Binding var searchTerm: String
    let mediaType: MediaType
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Environment(MoviesViewModel.self) var moviesVM

    var body: some View {
        @Bindable var moviesVM = moviesVM
        VStack {
            LazyVGrid(columns: columns, spacing: 8) {
                var seenMovieIDs = Set<Int>()
                ForEach(movies.filter { seenMovieIDs.insert($0.id).inserted }) { movie in
                    NavigationLink {
                        MovieScreen(movieId: movie.id)
                            .navigationBarBackButtonHidden()
                    } label: {
                        MediaGridItem(posterPath: movie.posterPath, voteAverage: movie.voteAverage)
//                            .environment(moviesVM)
                    }
                }
            }
        }
        .padding(16)
        .animation(.easeIn, value: moviesVM.searchedMovies)
    }
}

#Preview {
    GridItemsView(movies: [ShortMovie.preview], searchTerm: .constant(""), mediaType: .movie)
        .environment(MoviesViewModel())
}

