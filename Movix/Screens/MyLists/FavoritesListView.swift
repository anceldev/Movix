//
//  FavoritesListView.swift
//  Movix
//
//  Created by Ancel Dev account on 10/2/25.
//

import SwiftUI

struct FavoritesListView: View {
    let movies: [Movie]
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(movies) { movie in
                    NavigationLink {
                        MovieScreen(movieId: movie.id)
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
        .onAppear {
            print(movies)
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesListView(movies: [Movie.preview])
    }
}
