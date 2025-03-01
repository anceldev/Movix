//
//  MovieScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 1/3/25.
//

import SwiftUI

struct MovieScreen<Content:View>: View {
    
    let mediaId: Int
    @State private var showRateSlider = false
    @State private var currentRate: Int = 0
    @State private var movieVM = MovieViewModel()
    @State private var serieVM = SerieViewModel()
    @Environment(UserViewModel.self) var userVM
    @Environment(SeriesViewModel.self) var seriesVM
    
    var mediaType: MediaType
    
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
//                if let movie = movieVM.movie {
//                if let media{
                    ScrollViewReader { proxy in
                        ScrollView(.vertical) {
                            VStack(spacing: 0) {
//                                PosterView(movie: movie)
                                switch mediaType {
                                case .movie:
                                    if let movie = movieVM.movie {
//                                        PosterView(movie: movie)
                                    }
                                case .tv:
                                    if let serie = serieVM.serie {
//                                        PosterView(serie: serie)
                                    }
                                }
//                                    .environment(movieVM)
                                
                                HStack(spacing: 16) {
                                    Button(action: {
                                        withAnimation {
                                            proxy.scrollTo("movieTabs")
                                        }
                                    }, label: {
                                        ActionBarButtonLabel(label: "Rate", imageName: "rate", isOn: false)
                                    })
                                    
                                    Button(
                                        action: {
                                            addToFavorites()
                                        },
                                        label: {
                                            ActionBarButtonLabel(
                                                label: "Favorites",
                                                imageName: "heart-icon",
                                                isOn: false
                                            )
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
//                                OverviewView(
//                                    overview: media.overview
//                                )

//                                MovieTabsView()
//                                    .environment(movieVM)
//                                    .id("movieTabs")
                                MovieTabsView {
                                    switch mediaType {
                                    case .movie:
                                        GeneralTabView(
                                            id: movieVM.movie?.id ?? 0,
                                            currentRate: userVM.getCurrentMovieRating(movieId: movieVM.movie?.id)
                                        )
                                        .environment(movieVM)
                                    case .tv:
                                        Text("General tab view for series")
                                    }
                                }
                                .environment(movieVM)
                                .id("movieTabs")
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.bw10)
                        .background(ignoresSafeAreaEdges: .bottom)
                        .scrollIndicators(.hidden)
                    }
//                } else {
//                    ProgressView()
//                        .tint(.marsB)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                }
                Spacer()
            }
            .padding(.bottom, 44)
            .frame(maxHeight: .infinity)
            BannerTopBar(true)
                .padding(.top, 44)
        }
        .ignoresSafeArea(.all)
        .onAppear {
            Task {
                switch mediaType {
                case .movie:
                    await movieVM.getMovieDetails(id: mediaId)
//                    self.media = movieVM.movie
                case .tv:
                    await serieVM.getSerieDetails(id: mediaId)
//                    self.media = serieVM.serie
                }
            }
        }
        .swipeToDismiss()
    }
    private func addToFavorites() {
        Task {
            guard let movie = movieVM.movie else { return }
        
            await userVM.toggleFavoriteMovie(movie: movie)
            
        }
    }

}
//#Preview(body: {
//    NavigationStack {
//        MovieScreen(mediaId: Movie.preview.id, mediaType: .movie)
//    }
//    .environment(UserViewModel(user: User.preview))
//})
