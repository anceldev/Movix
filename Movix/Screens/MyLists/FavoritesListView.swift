//
//  FavoritesListView.swift
//  Movix
//
//  Created by Ancel Dev account on 10/2/25.
//

import SwiftUI

struct FavoritesListView: View {
    let movies: [Movie]
    @Environment(UserViewModel.self) var userVM
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(movies) { movie in
                    NavigationLink {
                        MovieScreen(movieId: movie.id)
                            .navigationBarBackButtonHidden()
                    } label: {
                        MediaRow(title: movie.title, backdropPath: movie.backdropPath, releaseDate: nil, voteAverage: movie.voteAverage) {
                            Button {
                                toggleFavorite(movie: movie)
                            } label: {
                                Image(.heartIcon)
                                    .foregroundStyle(.blue1)
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeOut, value: userVM.user.favoriteMovies)
    }
    private func toggleFavorite(movie: Movie) {
        Task {
            await userVM.toggleFavoriteMovie(movie: movie)
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesListView(movies: [Movie.preview])
            .environment(UserViewModel(user: User.preview))
    }
}
