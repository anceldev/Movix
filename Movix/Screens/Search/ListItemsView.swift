//
//  ListItemsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct ListItemsView: View {
    let movies: [ShortMovie]
    @Binding var searchTerm: String
    @Environment(MoviesViewModel.self) var moviesVM
    @State private var showLoadButton = false

    var body: some View {
        @Bindable var viewModel = moviesVM
        LazyVStack(alignment: .leading) {
            var seenMovieIDs = Set<Int>()
            ForEach(movies.filter { seenMovieIDs.insert($0.id).inserted }) { movie in
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
            Button {
                loadMoreMovies()
            } label: {
                Label("Ver más", systemImage: "chevron.down")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.blue1)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
    private func loadMoreMovies() {
        Task {
            if searchTerm.isEmpty {
                await moviesVM.getTrendingMovies()
            } else {
                await moviesVM.searchMovies(searchTerm: searchTerm)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ListItemsView(movies: [ShortMovie.preview], searchTerm: .constant(""))
            .environment(MoviesViewModel())
    }
}
