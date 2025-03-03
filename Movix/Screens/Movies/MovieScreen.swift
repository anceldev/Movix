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
    @State private var movieVM = MovieViewModel()
    @State private var selectedTab: MediaTab = .general
    
    init(movieId: Int) {
        self.movieId = movieId
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        VStack {
            if let movie = movieVM.movie {
                VStack {
                    MediaView(overview: movie.overview) {
                        PosterView(
                            posterPath: movie.posterPath,
                            duration: movie.duration,
                            isAdult: movie.isAdult,
                            releaseDate: movie.releaseDate?.releaseDate(),
                            genres: movie.genres
                        )
                    } tabContent: {
                        VStack {
                            CustomSegmentedControl(state: $selectedTab)
                            switch selectedTab {
                            case .general:
                                GeneralTabMovieView(
                                    id: movieVM.movie?.id ?? 0,
                                    currentRate: userVM.getCurrentMovieRating(movieId: movieVM.movie?.id)
                                )
                                .environment(movieVM)
                            case .details:
                                DetailsTabView(movie: movie)
                            case .reviews:
                                ReviewsTabView()
                            }
                        }
                    }
                }
                .environment(movieVM)
            }
        }
        .background(.bw10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .swipeToDismiss()
//        .ignoresSafeArea(.all)
        .ignoresSafeArea(.container, edges: .top)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Movies")
                    }
                    .foregroundStyle(.blue1)
                }
            }
        }
        .task {
            await movieVM.getMovieDetails(id: movieId)
        }
    }
    
}
#Preview {
    NavigationStack {
        MovieScreen(movieId: 11235)
            .environment(UserViewModel(user: User.preview))
    }
} 
