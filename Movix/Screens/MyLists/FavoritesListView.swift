//
//  FavoritesListView.swift
//  Movix
//
//  Created by Ancel Dev account on 10/2/25.
//

import SwiftUI

struct FavoritesListView<T: MediaItemProtocol>: View {
//    let movies: [Movie]
    let mediaItems: [T]
    @Environment(UserViewModel.self) var userVM
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(mediaItems) { media  in
                    NavigationLink {
//                        MediaScreen(movieId: movie.id)
//                        MediaScreen(mediaId: movie.id, mediaType: .movie)
//                            .navigationBarBackButtonHidden()
                        Text("Media screen")
                    } label: {
                        MediaRow(
                            title: media.title,
                            backdropPath: media.backdropPath,
                            releaseDate: nil,
                            voteAverage: media.voteAverage
                        ) {
                            Button {
//                                toggleFavorite(movie: movie)
//                                favoriteAction(movie)
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
//    private func toggleFavorite(movie: Movie) {
//        Task {
//            await favoriteAction(movie)
//        }
//    }
    private func toggleFavorite(movie: Movie) {
        Task {
//            await userVM.toggleFavoriteMovie(movie: movie)
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesListView(mediaItems: [Movie.preview])
            .environment(UserViewModel(user: User.preview))
    }
}
