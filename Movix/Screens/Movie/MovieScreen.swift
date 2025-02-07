//
//  MovieScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct MovieScreen: View {
    
    let movieId: Int
    //    @State private var castViewModel: CastViewModel
    @State private var showRateSlider = false
    @State private var currentRate: Float = 5.0
    //    @Environment(AuthViewModel.self) var authViewModel
    @State private var movieVM = MovieViewModel()
    
    init(movieId: Int) {
        self.movieId = movieId
        //        self._castViewModel = State(initialValue: CastViewModel(id: movieId))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                if let movie = movieVM.movie {
                    ScrollView(.vertical) {
                        PosterView(movie: movie)
                            .environment(movieVM)
                        MovieActionsBar(
                            idMovie: movie.id,
                            showRateSlider: $showRateSlider
                        )
                        .environment(movieVM)
                        MovieInfoView(
                            cast: movieVM.cast,
                            overview: movie.overview
                        )
                        MovieTabsView()
                            .environment(movieVM)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.bw10)
                    .background(ignoresSafeAreaEdges: .bottom)
                    .scrollIndicators(.hidden)
                } else {
                    ProgressView()
                        .tint(.marsB)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                    
                Spacer()
            }
            .frame(maxHeight: .infinity)
            BannerTopBar(true, true)
                .padding(.top, 44)
        }
        .padding(.bottom, 24)
        //        .sheet(isPresented: $showRateSlider) {
        //            RateView(currentRate: $currentRate, action: makeRate)
        //                .presentationDetents([.height(300)])
        //        }
//        .ignoresSafeArea()
        .onAppear {
            Task {
                await movieVM.getMovieDetails(id: movieId)
//                await movieVM.getMovieCast(id: movieId)
            }
        }
        .swipeToDismiss()
    }
}
#Preview(body: {
    NavigationStack {
        MovieScreen(movieId: Movie.preview.id)
        //            .environment(AuthViewModel())
    }
})
