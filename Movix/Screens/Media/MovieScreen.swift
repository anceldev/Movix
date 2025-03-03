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
                                Text("General tab content")
                            case .details:
                                Text("Details tab content")
                            case .reviews:
                                Text("Review tab content")
                            }
                        }
                    }
                }
            }
        }
        .swipeToDismiss()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Movies")
                    }
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
