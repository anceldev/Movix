//
//  MovieScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct MovieScreen: View {
    
    let movieId: Int
    @State private var showRateSlider = false
    @State private var currentRate: Float = 5.0
    @State private var movieVM = MovieViewModel()
    @Environment(UserViewModel.self) var userVM
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                if let movie = movieVM.movie {
                    ScrollViewReader { proxy in
                        ScrollView(.vertical) {
                            VStack(spacing: 0) {
                                PosterView(movie: movie)
                                    .environment(movieVM)
                                HStack(spacing: 16) {
                                    Button(action: {
                                        withAnimation {
                                            proxy.scrollTo("movieTabs")
                                        }
                                    }, label: {
                                        ActionBarButtonLabel(label: "Rate", imageName: "rate", isOn: false)
                                    })
                                    
                                    Button(action: {
                                        addToFavorites()
                                    }, label: {
                                        ActionBarButtonLabel(label: "Favorites", imageName: "heart-icon", isOn: true)
                                    })
                                    NavigationLink {
                                        Text("Lists screen")
                                    } label: {
                                        ActionBarButtonLabel(label: "My List", imageName: "shop", isOn: false)
                                    }
                                    NavigationLink {
                                        ProvidersScreen()
                                            .navigationBarBackButtonHidden()
                                            .environment(movieVM)
                                    } label: {
                                        VStack(spacing: 12) {
                                            VStack {
                                                Image(.providersIcon)
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                                    .padding(8)
                                                    .background(
                                                        LinearGradient(colors: [Color.marsA, Color.marsB], startPoint: .bottomLeading, endPoint: .topTrailing)
                                                    )
                                                    .clipShape(.circle)
                                                    .foregroundStyle(.white)
                                            }
                                            .frame(width: 30, height: 30)
                                            Text("Providers")
                                                .font(.hauora(size: 12))
                                                .foregroundStyle(.white)
                                        }
                                        .frame(width: 60)
                                    }
                                }
                                .padding(.top, 26)
                                MovieInfoView(
                                    cast: movieVM.cast,
                                    overview: movie.overview
                                )
                                MovieTabsView()
                                    .environment(movieVM)
                                    .id("movieTabs")
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.bw10)
                        .background(ignoresSafeAreaEdges: .bottom)
                        .scrollIndicators(.hidden)
                    }
                } else {
                    ProgressView()
                        .tint(.marsB)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                Spacer()
            }
            .padding(.bottom, 44)
            .frame(maxHeight: .infinity)
            BannerTopBar(true, true)
                .padding(.top, 44)
        }
        .ignoresSafeArea(.all)
        .onAppear {
            Task {
                await movieVM.getMovieDetails(id: movieId)
            }
        }
        .swipeToDismiss()
    }
    private func addToFavorites() {
        Task {
            if let movie = movieVM.movie {
                await userVM.addFavoriteMovie(movie: movie)
            }
        }
    }
}
#Preview(body: {
    NavigationStack {
        MovieScreen(movieId: Movie.preview.id)
    }
    .environment(UserViewModel(user: Account.preview))
})
