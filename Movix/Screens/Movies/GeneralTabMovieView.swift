//
//  GeneralTabMovieView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct GeneralTabMovieView: View {
    @Environment(MovieViewModel.self) var movieVM
    @Environment(UserViewModel.self) var userVM

    @State private var currentRate: Float
    @State private var castVM: CastViewModel
    
    init(id: Int, currentRate: Int? = nil) {
        self._castVM = State(initialValue: CastViewModel(id: id))
        self._currentRate = State(initialValue: Float(currentRate != nil ? currentRate! : 0))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if castVM.cast.count > 0 {
                CastView(cast: castVM.cast)
            }
            RatingView(mediaType: "movie", currentRate: $currentRate, action: rateMovie)
        }
        .onChange(of: currentRate) {
            print(Int(currentRate))
        }
    }
    private func rateMovie() {
        Task {
            guard let movie = movieVM.movie else { return }
            await userVM.addMovieRating(movie: movie, rating: Int(currentRate))
        }
    }
}

