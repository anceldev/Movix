//
//  MovieScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 1/3/25.
//

import SwiftUI

struct MovieScreen: View {

    let movieId: Int
    
    @Environment(UserViewModel.self) var userVM
    @Environment(\.dismiss) private var dismiss
    @Environment(NavigationManager.self) var navigationManager

    @State private var movieVM = MovieViewModel()
    @State private var selectedTab: MediaTab = .general
    @State private var showIcon = false
    
    var isFavorite: Bool {
        let media = userVM.user.movies.first { $0.media.id == movieId }
        guard let media else { return false }
        return media.isFavorite
    }

    init(movieId: Int) {
        self.movieId = movieId
    }

    var body: some View {
        VStack {
            if let movie = movieVM.movie {
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            PosterMediaView(
                                posterPath: movie.posterPath,
                                duration: movie.duration,
                                isAdult: movie.isAdult,
                                releaseDate: movie.releaseDate?.releaseDate(),
                                genres: movie.genres,
                                mediaType: .movie
                            )

                            MediaActionsBar(
                                media: .init(id: movie.id, posterPath: movie.posterPath),
                                mediaType: .movie,
                                isFavorite: isFavorite,
                                rateAction: {
                                    selectedTab = .general
                                    proxy.scrollTo("mediaTabs")
                                },
                                favoriteAction: toggleFavoriteMovie
                            )
                            
                            OverviewView(
                                title: movieVM.movie?.title,
                                overview: movie.overview)
                            VStack {
                                CustomSegmentedControl(state: $selectedTab)
                                switch selectedTab {
                                case .general:
                                    GeneralTabMovieView(
                                        id: movieVM.movie?.id ?? 0,
                                        currentRate:
                                            userVM.getMovieRating(
                                                movieId: movieId)
                                    )
                                    .id("mediaTabs")
                                case .details:
                                    DetailsTabView<Movie>(
                                        media: movieVM.movie!,
                                        similarAction: getSimilarSeries
                                    )
                                case .reviews:
                                    ReviewsList(
                                        id: movie.id, title: movie.title,
                                        mediaType: .movie)
                                }
                            }
                            .padding()
                        }
                        .environment(movieVM)
                        .environment(userVM)
                    }
                    .scrollIndicators(.hidden)
                }
            } else {
                ProgressView()
                    .tint(.marsB)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.bw10)
            }
        }
        .background(.bw10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .swipeToDismiss()
        .ignoresSafeArea(.container, edges: .top)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    navigationManager.navigateBack()
                } label: {
                    BackButton()
                }
            }
        }
        .task {
            await movieVM.getMovieDetails(id: movieId)
        }
    }
    private func getSimilarSeries() async -> [Movie] {
        return await movieVM.getRecommendedMovies(movieId: movieId)
    }
    private func toggleFavoriteMovie() async {
        if let movie = movieVM.movie {
            await userVM.toggleFavoriteMedia(media: movie, mediaType: .movie)
        }
    }
}
#Preview {
    NavigationStack {
        MovieScreen(movieId: 11235)
            .environment(UserViewModel(user: PreviewData.user))
            .environment(NavigationManager())
    }
}
