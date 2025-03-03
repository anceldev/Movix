//
//  GeneralTabSerieView.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct GeneralTabSerieView: View {
    @State private var currentRate: Float
    @Environment(SerieViewModel.self) var serieVM
    @Environment(UserViewModel.self) var userVM
    init(currentRate: Int? = nil) {
        self._currentRate = State(initialValue: Float(currentRate != nil ? currentRate! : 0))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if let seasons = serieVM.serie?.seasons,
               seasons.count > 0 {
                SeasonsView(seasons)
            }
            CastView(cast: serieVM.cast)
            RatingView(mediaType: "serie", currentRate: $currentRate, action: rateSerie)
        }
        .task {
            if let serie = serieVM.serie{
                await serieVM.getSerieCredits(id: serie.id)
            }
        }
    }
    private func rateSerie() {
        Task {
            guard let serie = serieVM.serie else { return }
            await userVM.addSerieRating(serie: serie, rating: Int(currentRate))
        }
    }
}

#Preview {
    GeneralTabSerieView()
        .environment(SerieViewModel())
        .environment(UserViewModel(user: User.preview))
}
