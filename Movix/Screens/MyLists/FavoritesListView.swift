//
//  FavoritesListView.swift
//  Movix
//
//  Created by Ancel Dev account on 10/2/25.
//

import SwiftUI

struct FavoritesListView: View {
    let movies: [SupMovie]
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(movies) { movie in
                    NavigationLink {
                        MovieScreen(movieId: movie.tmdbId)
                            .navigationBarBackButtonHidden()
                    } label: {
                        MediaRow(title: movie.title, backdropPath: movie.backdropPath, releaseDate: nil, voteAverage: nil) {
                            Button {
                                print("Liked or dislike")
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
    }
}

#Preview {
    NavigationStack {
        FavoritesListView(movies: [SupMovie.preview1, SupMovie.preview2])
    }
}
